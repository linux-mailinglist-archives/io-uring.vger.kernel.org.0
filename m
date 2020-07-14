Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F5021E591
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 04:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgGNCUT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 22:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGNCUS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 22:20:18 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11666C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 19:20:17 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k4so6351372pld.12
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 19:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HtmkYGzTFuW452BnXOdbhTomSYZgr3IwN1U9fl38Fzs=;
        b=c3N7iBVc2bjNcQylm1dESwbLApXmy6eltYcQoAQ/BUr/eI7nfA2KvTLbIb84cgfbcO
         U8zbiK36ftWRrdT3C9gem1w+S1HmRVb4EqtpyO5Iu+gNJPNbltJo6ZYUvdvqU2Tz3H9F
         5amB0zimdqDpnlssJmV3nl8nVVYM3g86wBKxeoPv2YKgdhyw2btmyC1wIkD4lhtdGfnp
         ZJp7YTSk/meSOPhRbK/2MIgHlYorS4+t1doEqIBXaNFeN2QOP8zj8SQ9oNcen+a6Uq/N
         ugQAyCAhTKSBonXhVe/+hZu0af/dY62ExQa3bB8O+M3ZtoOo3gfG93GvPHU9975NcxLP
         rdcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HtmkYGzTFuW452BnXOdbhTomSYZgr3IwN1U9fl38Fzs=;
        b=TiW4Q0XPMvUSDNTuicMP7zTmzNP3An5uadW5tjtVLHz2xnQcfTdfXK0CwVK3Ym8nTU
         ggvtj9RzHsLFlqvUQl3BmqrVYMDIRFDkY+dKMWCeS+VkewqZJyWyOPvvpw8a+7xHvjW2
         yGIUWeQFZvw9xtqyqTDoV8/SjeGNxurpkYqamoM4oWEHQ1Fy4ZS+lJ4pHoLAy3ZpFrqk
         KZrnV7cZc5ffSIeHOBWIr4PaLhStzbfb2MHhoxuZALXBzE04w8QmkLSH2CLX7jkUuPN1
         iFP7+8OYLZTWUtTO1adzeImbWuTWZ9uFiXlKOelxk+jw7hpXtVU8urzOrgmDTsowogqp
         uZKg==
X-Gm-Message-State: AOAM533/Fi4SGpCul6lZ7zqNbBtumfbapXpaXmwvx7L+u+gbU/fQZRLe
        lsDweIJ1dsYbA5OcYHf6buRvtb8NkpiUQA==
X-Google-Smtp-Source: ABdhPJyxMlP6ekqD2Vi8085LWPUG5cG04OCZ4fy3FUoLIK5WFBMBdokd4LOU/g33/H/TbGPp56ciHw==
X-Received: by 2002:a17:90a:d304:: with SMTP id p4mr2346975pju.153.1594693216153;
        Mon, 13 Jul 2020 19:20:16 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j70sm15306387pfd.208.2020.07.13.19.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 19:20:15 -0700 (PDT)
Subject: Re: IORING_OP_FILES_UPDATE fail with ECANCELED when IOSQE_IO_LINK is
 used
To:     Daniele Salvatore Albano <d.albano@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <CAKq9yRgVh9i-eBTXi5O1dLCwZ=kdmpakuP7K5xCVRkwhwTrB2Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <501e0c04-2b2b-a3e8-6172-890cb2b7e9cb@kernel.dk>
Date:   Mon, 13 Jul 2020 20:20:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAKq9yRgVh9i-eBTXi5O1dLCwZ=kdmpakuP7K5xCVRkwhwTrB2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/20 4:55 PM, Daniele Salvatore Albano wrote:
> Hi everyone,
> 
> I am trying to use IORING_OP_FILES_UPDATE  in combination with
> IOSQE_IO_LINK and IORING_OP_RECV / IORING_OP_RECV as linked op but I
> keep getting ECANCELED (errno 125).
> 
> I am using io_uring (kernel 5.8.0-rc4 built 3 days ago) and liburing (tag 0.7).
> 
> I went through the test cases and I wasn't able to find any
> combination of the OP and the flag and I can't find any related docs
> so I am not sure if the combo isn't allowed.
> 
> Although I have found
> https://github.com/torvalds/linux/blob/v5.8-rc5/fs/io_uring.c#L4926
> 
>  if (sqe->flags || sqe->ioprio || sqe->rw_flags)
>     return -EINVAL;
> 
> Not sure if this is the reason for which the linked operation is
> failing, I don't see in the other *_prep sqe->flags being broadly
> checked in general.
> 
> I wrote two simple test cases that perform the following sequence of operations:
> - open a local file (for the two test cases below /proc/cmdline)
> - IORING_OP_FILES_UPDATE +  IOSQE_IO_LINK (only in the first test case)
> - IORING_OP_READ + IOSQE_FIXED_FILE
> 
> Here a small test case to trigger the issue I am facing
> 
> int main() {
>     struct io_uring ring = {0};
>     uint32_t head, count = 0;
>     struct io_uring_sqe *sqe = NULL;
>     struct io_uring_cqe *cqe = NULL;
>     uint32_t files_map_count = 16;
>     const int *files_map_registered = malloc(sizeof(int) * files_map_count);
>     memset((void*)files_map_registered, 0, sizeof(int) * files_map_count);
> 
>     io_uring_queue_init(16, &ring, 0);
>     io_uring_register_files(&ring, files_map_registered, files_map_count);
> 
>     int fd = open("/proc/cmdline", O_RDONLY);
>     int fd_index = 10;
> 
>     sqe = io_uring_get_sqe(&ring);
>     io_uring_prep_files_update(sqe, &fd, 1, fd_index);
>     io_uring_sqe_set_flags(sqe, IOSQE_IO_LINK);
>     sqe->user_data = 1;
> 
>     char buffer[512] = {0};
>     sqe = io_uring_get_sqe(&ring);
>     io_uring_prep_read(sqe, fd_index, &buffer, sizeof(buffer), 0);
>     io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE);
>     sqe->user_data = 2;
> 
>     io_uring_submit_and_wait(&ring, 2);
> 
>     io_uring_for_each_cqe(&ring, head, cqe) {
>         count++;
> 
>         fprintf(stdout, "count = %d\n", count);
>         fprintf(stdout, "cqe->res = %d\n", cqe->res);
>         fprintf(stdout, "cqe->user_data = %llu\n", cqe->user_data);
>         fprintf(stdout, "cqe->flags = %u\n", cqe->flags);
>     }
> 
>     io_uring_cq_advance(&ring, count);
> 
>     io_uring_unregister_files(&ring);
>     io_uring_queue_exit(&ring);
> 
>     return 0;
> }
> 
> It will report for both the cqes res = -125
> 
> Instead if the code doesn't link and wait for the read it works as I
> am expecting.
> 
> int main() {
>     struct io_uring ring = {0};
>     uint32_t head, count = 0;
>     char buffer[512] = {0};
>     struct io_uring_sqe *sqe = NULL;
>     struct io_uring_cqe *cqe = NULL;
>     uint32_t files_map_count = 16;
>     const int *files_map_registered = malloc(sizeof(int) * files_map_count);
>     memset((void*)files_map_registered, 0, sizeof(int) * files_map_count);
> 
>     io_uring_queue_init(16, &ring, 0);
>     io_uring_register_files(&ring, files_map_registered, files_map_count);
> 
>     int fd = open("/proc/cmdline", O_RDONLY);
>     int fd_index = 10;
> 
>     sqe = io_uring_get_sqe(&ring);
>     io_uring_prep_files_update(sqe, &fd, 1, fd_index);
>     io_uring_sqe_set_flags(sqe, 0);
>     sqe->user_data = 1;
> 
>     int exit_loop = 0;
>     do {
>         io_uring_submit_and_wait(&ring, 1);
> 
>         io_uring_for_each_cqe(&ring, head, cqe) {
>             count++;
> 
>             fprintf(stdout, "count = %d\n", count);
>             fprintf(stdout, "cqe->res = %d\n", cqe->res);
>             fprintf(stdout, "cqe->user_data = %llu\n", cqe->user_data);
>             fprintf(stdout, "cqe->flags = %u\n", cqe->flags);
> 
>             if (cqe->user_data == 1) {
>                 sqe = io_uring_get_sqe(&ring);
>                 io_uring_prep_read(sqe, fd_index, &buffer, sizeof(buffer), 0);
>                 io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE);
>                 sqe->user_data = 2;
>             } else {
>                 if (cqe->res >= 0) {
>                     fprintf(stdout, "buffer = <");
>                     fwrite(buffer, cqe->res, 1, stdout);
>                     fprintf(stdout, ">\n");
>                 }
> 
>                 exit_loop = 1;
>             }
>         }
> 
>         io_uring_cq_advance(&ring, count);
>     } while(exit_loop == 0);
> 
>     io_uring_unregister_files(&ring);
>     io_uring_queue_exit(&ring);
> 
>     return 0;
> }
> 
> The output here is
> count = 1
> cqe->res = 1
> cqe->user_data = 1
> cqe->flags = 0
> count = 2
> cqe->res = 58
> cqe->user_data = 2
> cqe->flags = 0
> buffer = <initrd=....yada yada yada...>
> 
> Is this the expected behaviour? If no, any hint? What am I doing wrong?
> 
> If the expected behaviour is that IORING_OP_FILES_UPDATE can't be
> linked, how can I use it properly to issue a read or another op that
> requires to work with fds in a chain of operations?

I think the sqe->flags should just be removed, as you're alluding to.
Care to send a patch for that? Then I can queue it up. We can even mark
it stable to ensure it gets back to older kernels.

Probably just want to make it something ala:

unsigned flags = READ_ONCE(sqe->flags);

if (flags & (IOSQE_FIXED_FILE | IOSQE_BUFFER_SELECT))
	return -EINVAL;

as those flags don't make sense, but the rest do.

-- 
Jens Axboe

