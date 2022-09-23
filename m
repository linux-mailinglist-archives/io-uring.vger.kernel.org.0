Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C00D5E7D1C
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 16:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiIWOcX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 10:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiIWOcV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 10:32:21 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743E313EEA2
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:32:20 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n10so235152wrw.12
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=BqFcqfNTG2GvCpxZGGXPwBR88LLMz8saElhg5eR1FAQ=;
        b=QwBknRSPLmBTxD58lZ+VaiRp+e8/kh3ItU5drA/MIm6g8kLz9bYOhce6v/EAiqIgEU
         MzSX5NQ1kF9S79EX4xwxUa5ma4DydkHCAzCMePqdYxWykJIAjc4n4ymzr+tyhzQKQ341
         NRn+PNUePIAyDBOpxdiOt1QI1AgX77SAYN2m8NWha38HVDgqlGsJKf5Rdm8gapEqG3jF
         3Wk+L9Rzq7kC0XgejHPJka/mlGc3MKIju+Rjs9fmv/HJFaUHEST/svJuenJ6k8aCnfQW
         rZHJJ9OG4iHnvhgI33tUAEE6J5HXODSRh3LQBWbOC8y1q/TjRnyj/LgbEJjlbhqHTPNV
         NZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=BqFcqfNTG2GvCpxZGGXPwBR88LLMz8saElhg5eR1FAQ=;
        b=6nglq0pcX+FAbdbgldOYp6DmF57u6LltHdkYWSoNI6bpLhs7XZ2+0HW1ThsdhYGT2M
         rC/bK8CKH4ySSS1ZGoV66cIhgassOuZppBziuf3Tntl2yieNcgS2IYcAIXEbKuuuyHQu
         nlVxiy72mfmmulM53XQGxyU0mHuxQZI3RYauYsZLWEQXmANcTHlwX5yZjQeScjXoZZJ/
         ii4vxHRGqJ85IQWvTH6FutKSlxTKXB/iOaH3Txck40RmmeFdfSHv0aIFeEDfbE5yMYEg
         g+CDv5NeJoYFrO5kbk4/ryO2G99FsnuDIW0pSUdi3lgOHfoYec4rah5LJ5w4zvqKr6lD
         YK7w==
X-Gm-Message-State: ACrzQf3uMhec5bkBbdn5B+ZrZvBPrzk/OGz2Ry1soDEEJUA8bmgOEOSt
        o+9E16B858pL7x6imm8T6AOw4Qas0ic=
X-Google-Smtp-Source: AMsMyM4iAcqlenTVGuevXo1zPqMGmK+8pNubZ5T+OcYC7Q+GvdzODXKHOtvucYoE5rtyM+gd6W0RDg==
X-Received: by 2002:a05:6000:178d:b0:226:ffe8:72df with SMTP id e13-20020a056000178d00b00226ffe872dfmr5332959wrg.496.1663943538610;
        Fri, 23 Sep 2022 07:32:18 -0700 (PDT)
Received: from [192.168.8.198] (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id n13-20020adfe34d000000b002285f73f11dsm9177084wrj.81.2022.09.23.07.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 07:32:18 -0700 (PDT)
Message-ID: <b51332a9-5ce3-fed4-10cd-ea3b5d8dff33@gmail.com>
Date:   Fri, 23 Sep 2022 15:31:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-next 1/1] io_uring/net: fix UAF in io_sendrecv_fail()
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>,
        syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com
References: <49ee34929051a668e4829b6549dcd3eba49bf95b.1663941567.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <49ee34929051a668e4829b6549dcd3eba49bf95b.1663941567.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/23/22 14:59, Pavel Begunkov wrote:
> We should not assume anything about ->free_iov just from
> REQ_F_ASYNC_DATA but rather rely on REQ_F_NEED_CLEANUP, as we may
> allocate ->async_data but failed init would leave the field in not
> consistent state. The easiest solution is to remove removing
> REQ_F_NEED_CLEANUP and so ->async_data dealloc from io_sendrecv_fail()
> and let io_send_zc_cleanup() do the job. The catch here is that we also
> need to prevent double notif flushing, just test it for NULL and zero
> where it's needed.
> 
> BUG: KASAN: use-after-free in io_sendrecv_fail+0x3b0/0x3e0 io_uring/net.c:1221
> Write of size 8 at addr ffff8880771b4080 by task syz-executor.3/30199
> 
> CPU: 1 PID: 30199 Comm: syz-executor.3 Not tainted 6.0.0-rc6-next-20220923-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>   print_address_description mm/kasan/report.c:284 [inline]
>   print_report+0x15e/0x45d mm/kasan/report.c:395
>   kasan_report+0xbb/0x1f0 mm/kasan/report.c:495
>   io_sendrecv_fail+0x3b0/0x3e0 io_uring/net.c:1221
>   io_req_complete_failed+0x155/0x1b0 io_uring/io_uring.c:873
>   io_drain_req io_uring/io_uring.c:1648 [inline]
>   io_queue_sqe_fallback.cold+0x29f/0x788 io_uring/io_uring.c:1931
>   io_submit_sqe io_uring/io_uring.c:2160 [inline]
>   io_submit_sqes+0x1180/0x1df0 io_uring/io_uring.c:2276
>   __do_sys_io_uring_enter+0xac6/0x2410 io_uring/io_uring.c:3216
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd

Missed unused var, will resend

> 
> Fixes: c4c0009e0b56e ("io_uring/net: combine fail handlers")
> Reported-by: syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/net.c | 14 +++++---------
>   1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 757a300578f4..e9e66bace45f 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -915,9 +915,11 @@ void io_send_zc_cleanup(struct io_kiocb *req)
>   		io = req->async_data;
>   		kfree(io->free_iov);
>   	}
> -	zc->notif->flags |= REQ_F_CQE_SKIP;
> -	io_notif_flush(zc->notif);
> -	zc->notif = NULL;
> +	if (zc->notif) {
> +		zc->notif->flags |= REQ_F_CQE_SKIP;
> +		io_notif_flush(zc->notif);
> +		zc->notif = NULL;
> +	}
>   }
>   
>   int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> @@ -1215,12 +1217,6 @@ void io_sendrecv_fail(struct io_kiocb *req)
>   		io_notif_flush(sr->notif);
>   		sr->notif = NULL;
>   	}
> -	if (req_has_async_data(req)) {
> -		io = req->async_data;
> -		kfree(io->free_iov);
> -		io->free_iov = NULL;
> -	}
> -	req->flags &= ~REQ_F_NEED_CLEANUP;
>   	io_req_set_res(req, res, req->cqe.flags);
>   }
>   

-- 
Pavel Begunkov
