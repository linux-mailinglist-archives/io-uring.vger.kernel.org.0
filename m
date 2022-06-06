Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E7853E810
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 19:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbiFFNsD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 09:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239057AbiFFNsD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 09:48:03 -0400
Received: from pv50p00im-ztbu10021601.me.com (pv50p00im-ztbu10021601.me.com [17.58.6.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C5A9B190
        for <io-uring@vger.kernel.org>; Mon,  6 Jun 2022 06:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1654523281;
        bh=Xrh3zL68zcWdv3M5jS/Ncj4X+OT7/Wi9hfH7M/fiU9w=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=Cbfgybt/SKww7Bpf0WHljcohHGmxj+t+JALt7vYY/kmXKndsATbS23ovqiDsAA+qf
         tzmYuLTLHbgrACNHj80PJn5JMuik/xVISi/XBOcw/8p5SHLTEYgrf8J4l7RzL8KJR6
         PbVxTGnaQ/Y14BrDnaqEAsV2pv4+OSO46joZbi5g9j1wlyMf40hjW6nQm8XNPOpTG7
         6qDoTbJv3YdLwXbansDKsa/SlJxQZDFXbiR8bdNygkuVpEzBheeweivtgCEj7em4xI
         dvIqv5qAW5pA3bhnY3YgCe1KVmm8xy2Kfry6dSXWa8Q1r3wMXIn7Hz+wMr81xgH0cM
         MnQEPTTxeS3dQ==
Received: from [10.97.63.88] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztbu10021601.me.com (Postfix) with ESMTPSA id CB12180599;
        Mon,  6 Jun 2022 13:47:58 +0000 (UTC)
Message-ID: <824ba662-d2af-f62e-15e8-b0762258243e@icloud.com>
Date:   Mon, 6 Jun 2022 21:47:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/3] io_uring: add hash_index and its logic to track req
 in cancel_hash
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220606065716.270879-1-haoxu.linux@icloud.com>
 <20220606065716.270879-2-haoxu.linux@icloud.com>
 <3e1eaa9d-9b96-84a8-8fca-539bea3c24ae@gmail.com>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <3e1eaa9d-9b96-84a8-8fca-539bea3c24ae@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_04:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=943 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2206060063
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/22 19:59, Pavel Begunkov wrote:
> On 6/6/22 07:57, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Add a new member hash_index in struct io_kiocb to track the req index
>> in cancel_hash array. This is needed in later patches.
>>
>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>> ---
>>   io_uring/io_uring_types.h | 1 +
>>   io_uring/poll.c           | 4 +++-
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
>> index 7c22cf35a7e2..2041ee83467d 100644
>> --- a/io_uring/io_uring_types.h
>> +++ b/io_uring/io_uring_types.h
>> @@ -474,6 +474,7 @@ struct io_kiocb {
>>               u64        extra2;
>>           };
>>       };
>> +    unsigned int            hash_index;
> 
> Didn't take a closer look, but can we make rid of it?
> E.g. computing it again when ejecting a request from
> the hash? or keep it in struct io_poll?

Good point, I prefer moving it to io_poll to computing it again since
this patchset is to try to make it faster.

