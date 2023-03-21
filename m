Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1001C6C3AF4
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 20:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCUTrH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 15:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCUTrE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 15:47:04 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA685550A
        for <io-uring@vger.kernel.org>; Tue, 21 Mar 2023 12:46:36 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id r4so8728074ilt.8
        for <io-uring@vger.kernel.org>; Tue, 21 Mar 2023 12:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679427956; x=1682019956;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dkE1pW/0Rohn7ZF+HYuEeP5PaG7Mjq0D1yToJ56Ti5I=;
        b=5SLAcQWwL7GztuZQ1+aBGzUEW5GpP/Dzf6617eBPHyjnGjpAGmMuT1FI4/uRadpYwh
         OvHTtVc3zP80ngTlXRFNdrxcA8w484V9EK+Y4OzCYSeLt0RFuL8L2US3afK7z+38QVJ1
         jbG79EDJd2ADoziZwE74mjfvoiKO6fo23ViK+KslN15GIcqy6kU1cWW/oS7e4B8GzugE
         WEGi5OuQepgHuiVVsnNJC4L1z5Yqg9MM3tkUUqSewx4UajALuXu8aRjrwz9qFC407opt
         MWPTAWoFUugJC02kxZq7aw+6uNVmLrjbvLWlTlDhN5/RjMV54f6kYYoEe6fyta8bVQxn
         SylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679427956; x=1682019956;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dkE1pW/0Rohn7ZF+HYuEeP5PaG7Mjq0D1yToJ56Ti5I=;
        b=ikWdzm1zqsLuUqi796D0ucickij1HuIAWSQbrXxfBbORVdpTnOIp956L6OjxN6Cubl
         cJ8wVeTD67K6NGy8Qv6aRPB/84GJQe4uTb+lD83qzLpztVdNbfzDymcyWf1jx4sEGkPQ
         ukzcUZsTf7Tf7RDh/Z2PcjdxUbNgAsFPP0iVrXlQ9n2RdSDlg62fzmx6rsc1M+k/DE6U
         Nkq4KpyRk0CEPYSCNI1sVCJavtsYm0/mvIXAtR56HXUtNdsISGlV+Bje9cMJU7+1XMc6
         6DXOB8PMVwShhpQHS8j8qJyCCqCRpPeKPINXvOSov3uVE8omdGucR0aaKAFpdE0PctKN
         4Ifg==
X-Gm-Message-State: AO0yUKUW+8Og0Z28x5c3a2AuzyTFlaUq+1hbW3abaHfGN3lYzJsQlNhn
        QXGigNbY2J5FOLV4j9ccW7Vb0A==
X-Google-Smtp-Source: AK7set/Eo5FGl3GwGawtCjC92aZqJP0n/SET5GrW8NmxvUhc66fz3zeJi5WFUOwE1eS0UkZqnOpQMg==
X-Received: by 2002:a05:6e02:1a84:b0:316:67be:1b99 with SMTP id k4-20020a056e021a8400b0031667be1b99mr2586805ilv.0.1679427956565;
        Tue, 21 Mar 2023 12:45:56 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b27-20020a026f5b000000b00406192f7335sm4432738jae.98.2023.03.21.12.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 12:45:56 -0700 (PDT)
Message-ID: <6ff0ef43-d426-00e1-bdf6-089c5cdb4f37@kernel.dk>
Date:   Tue, 21 Mar 2023 13:45:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] io_uring/rsrc: fix null-ptr-deref in io_file_bitmap_get()
Content-Language: en-US
To:     Savino Dicanosa <sd7.dev@pm.me>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20230321194300.405130-1-sd7.dev@pm.me>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230321194300.405130-1-sd7.dev@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/23 1:44 PM, Savino Dicanosa wrote:
> When fixed files are unregistered, file_alloc_end and alloc_hint
> are not cleared. This can later cause a NULL pointer dereference in
> io_file_bitmap_get() if auto index selection is enabled via
> IORING_FILE_INDEX_ALLOC:
> 
> [    6.519129] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [...]
> [    6.541468] RIP: 0010:_find_next_zero_bit+0x1a/0x70
> [...]
> [    6.560906] Call Trace:
> [    6.561322]  <TASK>
> [    6.561672]  io_file_bitmap_get+0x38/0x60
> [    6.562281]  io_fixed_fd_install+0x63/0xb0
> [    6.562851]  ? __pfx_io_socket+0x10/0x10
> [    6.563396]  io_socket+0x93/0xf0
> [    6.563855]  ? __pfx_io_socket+0x10/0x10
> [    6.564411]  io_issue_sqe+0x5b/0x3d0
> [    6.564914]  io_submit_sqes+0x1de/0x650
> [    6.565452]  __do_sys_io_uring_enter+0x4fc/0xb20
> [    6.566083]  ? __do_sys_io_uring_register+0x11e/0xd80
> [    6.566779]  do_syscall_64+0x3c/0x90
> [    6.567247]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [...]
> 
> To fix the issue, set file alloc range and alloc_hint to zero after
> file tables are freed.
> 
> Fixes: 4278a0deb1f6 ("io_uring: defer alloc_hint update to io_file_bitmap_set()")
> Signed-off-by: Savino Dicanosa <sd7.dev@pm.me>
> ---
>  io_uring/rsrc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index e2bac9f89902..7a43aed8e395 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -794,6 +794,7 @@ void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
>  	}
>  #endif
>  	io_free_file_tables(&ctx->file_table);
> +	io_file_table_set_alloc_range(ctx, 0, 0);
>  	io_rsrc_data_free(ctx->file_data);
>  	ctx->file_data = NULL;
>  	ctx->nr_user_files = 0;

That looks good. Do you happen to have a test case as well? Would be nice
to add that to the liburing regression tests.

-- 
Jens Axboe


