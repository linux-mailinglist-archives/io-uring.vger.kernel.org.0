Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC667351F2
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 12:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjFSKZ0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 06:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjFSKZQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 06:25:16 -0400
X-Greylist: delayed 1720 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 19 Jun 2023 03:25:14 PDT
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC88FCA
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 03:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:From:To:Date:Message-ID;
        bh=friqWOpJxkXdOfLddmroCxD9YaWLCI5fRrruRvQyMuE=; b=ERNJ1DMWfAEjo7LFO8Cb4wrEka
        j32BxyG8/fs74nMwSjYQru35ayef9ZYAuqgkCh7XbjV73vkDU9spst66LZbAzxfavou+rHGxwBjr/
        Ln5g19bc93XW1wEUEa00uhIE9ZqtB4cuYKDvk/GtYqLtmu9oux8H9SVWv+q8nltiUmWVaBEx+Gulq
        XVA49gvYc/uEsbSbkFmZLayH9jSXB4QfPpvJ4iv4G0SEGrxyi3KeKn3zkqEkP6VoL5TKVf8Kp+rwW
        mpaxxJf0NyNOsE5LygZZQqnAauALsBB584vD/2P7OR/vZIBYGOBvXvHZc08uKEp87g8CWRxRuv0ov
        2QGqOsjW7Z3TeyX76kyIH5BgVJqqso67Roog1V+XBDCynNcgFrLcb0Q9VxorKhwfpve5IkR4VKnJs
        deiDBqklcFc5UYtwDF6YvopY+Hrc8VKL1LGQLg6xt+1b6L40P5rI9J6uKZFoxhkDvVVvRE80rV/WH
        O5CJJ8IjSpXyojOsrSAcMNZ6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qBBcd-00306E-2G;
        Mon, 19 Jun 2023 09:56:31 +0000
Message-ID: <b104c37a-a605-e3c8-67ab-45f27e158e21@samba.org>
Date:   Mon, 19 Jun 2023 11:57:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: save msghdr->msg_control for retries
To:     Jens Axboe <axboe@kernel.dk>
References: <0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk>
Content-Language: en-US
From:   Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>
In-Reply-To: <0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk>
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

Hi Jens,

> If the application sets ->msg_control and we have to later retry this
> command, or if it got queued with IOSQE_ASYNC to begin with, then we
> need to retain the original msg_control value. This is due to the net
> stack overwriting this field with an in-kernel pointer, to copy it
> in. Hitting that path for the second time will now fail the copy from
> user, as it's attempting to copy from a non-user address.

I'm not 100% sure about the impact of this change.

But I think the logic we need is that only the
first __sys_sendmsg_sock() that returns > 0 should
see msg_control. A retry because of MSG_WAITALL should
clear msg_control[len] for a follow up __sys_sendmsg_sock().
And I fear the patch below would not clear it...

Otherwise the receiver/socket-layer will get the same msg_control twice,
which is unexpected.

metze
