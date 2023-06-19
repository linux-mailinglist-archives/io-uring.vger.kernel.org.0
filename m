Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC11573580C
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 15:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjFSNJk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 09:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjFSNJj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 09:09:39 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F045710C8
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 06:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=ICGgZOdImGYlUmaXrrix1njmCB5pl8GLCxNAj+Tf1RM=; b=yFH7sIO1LnsA1r4lHz52xBGz5w
        qe+5pAfNUltkIuYDhhflivYsvQLF/bdSoYxbvCeIphpGz5UdZVYjKeG8BqynH7iFO1LtlkP3N5ieo
        jXFjzLeCW04pqCha5S2RPqAkb/IS1vCZ3e4liS/0NK825DXaMWN3LDpC9kwCv5jhrnCXg1o0XYr6D
        ZxzcMCnTFaj0qe1ZfEAw8oIxfpZlPzMjrpj0ED1g1GosLzo0c81MArbMl5VvPjcc8rwNkQOA1ttjU
        OTckDL4l8IjNMnQpovLMkahxuuK5jm4WJz6GKc0rcB6VqKKrvDcAfN8bpUNWtCGciGjZE2Rs3v70V
        lOzDv3hf+9yzlHBPCxvHGuLqFB/sa5wmuPPS9b9OPu9lnqNbvHLOYHgqXkHlVK/9fU2L0nqsD045O
        b41HKg7kPiWTStuCHM0mJp2rgW3dbfAQywjW7HsqlcrfuDUmk7gkemCAULKm+r92AFLE+ciB2TwP2
        7jlUMEnw3JVHwRMkOEFbmuGq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qBEd2-0032k3-0c;
        Mon, 19 Jun 2023 13:09:08 +0000
Message-ID: <10d83431-656f-a70a-de4a-efe32af0d324@samba.org>
Date:   Mon, 19 Jun 2023 15:09:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: save msghdr->msg_control for retries
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk>
 <b104c37a-a605-e3c8-67ab-45f27e158e21@samba.org>
 <d98ebddb-89b9-e0d2-8390-69a3ab53b985@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <d98ebddb-89b9-e0d2-8390-69a3ab53b985@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 19.06.23 um 15:05 schrieb Jens Axboe:
> On 6/19/23 3:57?AM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>>> If the application sets ->msg_control and we have to later retry this
>>> command, or if it got queued with IOSQE_ASYNC to begin with, then we
>>> need to retain the original msg_control value. This is due to the net
>>> stack overwriting this field with an in-kernel pointer, to copy it
>>> in. Hitting that path for the second time will now fail the copy from
>>> user, as it's attempting to copy from a non-user address.
>>
>> I'm not 100% sure about the impact of this change.
>>
>> But I think the logic we need is that only the
>> first __sys_sendmsg_sock() that returns > 0 should
>> see msg_control. A retry because of MSG_WAITALL should
>> clear msg_control[len] for a follow up __sys_sendmsg_sock().
>> And I fear the patch below would not clear it...
>>
>> Otherwise the receiver/socket-layer will get the same msg_control twice,
>> which is unexpected.
> 
> Yes agree, if we do transfer some (but not all) data and WAITALL is set,
> it should get cleared. I'll post a patch for that.

Thanks!

> Note that it was also broken before, just differently broken. The most
> likely outcome here was a full retry and now getting -EFAULT.

Yes, I can see that it was broken before...

metze
