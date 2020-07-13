Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0AD21E34E
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 00:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGMW4G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 18:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgGMW4F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 18:56:05 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847D7C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 15:56:05 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o2so1863581wmh.2
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 15:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=apuSVBAtqnNteMIo3l1TNOGbRPkJ/8ftqi8p7DvY18E=;
        b=hDraSm1YehWgRuevqp/KGzvPN9T5kxJaiDvz5BdadWvxnsaBUPNUMZKl+goJR0gCDv
         /x51BoTwxze+PLo/9dM/9ahr1CsekvYYdRXA3QcVW1Gnqm7chDG1cr+Qu7sP4gdO/Nk7
         ngfTFou+w6QstFSh1CEyTcd0vc5b1K5vXA6m6llTNJzKcJeLncPI59ycZYcRi91JAAvg
         oJpOD8IlsW817TZYvL66z8gPpeexwjbHYj81JGCZmKwzfl4eWIiBTCP/K7zFB3FRxuqd
         XKiifkdWBcNDkewpnYsuulvIyUnF4VrEGNIQvrtNAWRqL1ilGk0ChGBJYfmxQ0/8KTLb
         bZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=apuSVBAtqnNteMIo3l1TNOGbRPkJ/8ftqi8p7DvY18E=;
        b=Dt7AGFWPABtYIYoWVvzt3Ei3e4otv6Hsnqq9lNKRg8bvD9YgRDf8OExuPj2yn87DMT
         x2QubxwfzxiFyempYj5mYGgVpqlKxcTxKQhg5PUhhLmFjgWavCJ1hLKJJbo8Ns2Kv783
         XavKzT+prmIljkPCxatuJShG3yD/tPgcFLIQTqTVQssWv82bDn3AfiFhtyZ1jTV0VSGy
         sZzby3z1S6Ow2YitZXhE0af127W9mJRqH7CGnh7ACXjIH8F3Soe+CzzF4tYaKr5THzoZ
         EqtUrXIdfamY2cSAi/zzcqwzcT6RPDKBF+bXXlqkFzf7z8pLsEHwfrP7E8qr/g5sGFn1
         lM4A==
X-Gm-Message-State: AOAM530h0wzzmjRr6EH2mHfQvS/PmZZWY00hSOnfWh2ze1mPPFA0N2UZ
        +9j+3iV7E6oJ6kroY3g7VmCRKYVIi59anA54Q0MY5BEG
X-Google-Smtp-Source: ABdhPJxCuv7J63Sn16cUkBsx0cO72kupnBXEA4n/j90XmTNuHiPm61C7sGqLIThIzJKp0g8cJUIFUQibpiXaNVGHy+w=
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr1470080wmh.130.1594680963753;
 Mon, 13 Jul 2020 15:56:03 -0700 (PDT)
MIME-Version: 1.0
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Mon, 13 Jul 2020 23:55:36 +0100
Message-ID: <CAKq9yRgVh9i-eBTXi5O1dLCwZ=kdmpakuP7K5xCVRkwhwTrB2Q@mail.gmail.com>
Subject: IORING_OP_FILES_UPDATE fail with ECANCELED when IOSQE_IO_LINK is used
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone,

I am trying to use IORING_OP_FILES_UPDATE  in combination with
IOSQE_IO_LINK and IORING_OP_RECV / IORING_OP_RECV as linked op but I
keep getting ECANCELED (errno 125).

I am using io_uring (kernel 5.8.0-rc4 built 3 days ago) and liburing (tag 0.7).

I went through the test cases and I wasn't able to find any
combination of the OP and the flag and I can't find any related docs
so I am not sure if the combo isn't allowed.

Although I have found
https://github.com/torvalds/linux/blob/v5.8-rc5/fs/io_uring.c#L4926

 if (sqe->flags || sqe->ioprio || sqe->rw_flags)
    return -EINVAL;

Not sure if this is the reason for which the linked operation is
failing, I don't see in the other *_prep sqe->flags being broadly
checked in general.

I wrote two simple test cases that perform the following sequence of operations:
- open a local file (for the two test cases below /proc/cmdline)
- IORING_OP_FILES_UPDATE +  IOSQE_IO_LINK (only in the first test case)
- IORING_OP_READ + IOSQE_FIXED_FILE

Here a small test case to trigger the issue I am facing

int main() {
    struct io_uring ring = {0};
    uint32_t head, count = 0;
    struct io_uring_sqe *sqe = NULL;
    struct io_uring_cqe *cqe = NULL;
    uint32_t files_map_count = 16;
    const int *files_map_registered = malloc(sizeof(int) * files_map_count);
    memset((void*)files_map_registered, 0, sizeof(int) * files_map_count);

    io_uring_queue_init(16, &ring, 0);
    io_uring_register_files(&ring, files_map_registered, files_map_count);

    int fd = open("/proc/cmdline", O_RDONLY);
    int fd_index = 10;

    sqe = io_uring_get_sqe(&ring);
    io_uring_prep_files_update(sqe, &fd, 1, fd_index);
    io_uring_sqe_set_flags(sqe, IOSQE_IO_LINK);
    sqe->user_data = 1;

    char buffer[512] = {0};
    sqe = io_uring_get_sqe(&ring);
    io_uring_prep_read(sqe, fd_index, &buffer, sizeof(buffer), 0);
    io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE);
    sqe->user_data = 2;

    io_uring_submit_and_wait(&ring, 2);

    io_uring_for_each_cqe(&ring, head, cqe) {
        count++;

        fprintf(stdout, "count = %d\n", count);
        fprintf(stdout, "cqe->res = %d\n", cqe->res);
        fprintf(stdout, "cqe->user_data = %llu\n", cqe->user_data);
        fprintf(stdout, "cqe->flags = %u\n", cqe->flags);
    }

    io_uring_cq_advance(&ring, count);

    io_uring_unregister_files(&ring);
    io_uring_queue_exit(&ring);

    return 0;
}

It will report for both the cqes res = -125

Instead if the code doesn't link and wait for the read it works as I
am expecting.

int main() {
    struct io_uring ring = {0};
    uint32_t head, count = 0;
    char buffer[512] = {0};
    struct io_uring_sqe *sqe = NULL;
    struct io_uring_cqe *cqe = NULL;
    uint32_t files_map_count = 16;
    const int *files_map_registered = malloc(sizeof(int) * files_map_count);
    memset((void*)files_map_registered, 0, sizeof(int) * files_map_count);

    io_uring_queue_init(16, &ring, 0);
    io_uring_register_files(&ring, files_map_registered, files_map_count);

    int fd = open("/proc/cmdline", O_RDONLY);
    int fd_index = 10;

    sqe = io_uring_get_sqe(&ring);
    io_uring_prep_files_update(sqe, &fd, 1, fd_index);
    io_uring_sqe_set_flags(sqe, 0);
    sqe->user_data = 1;

    int exit_loop = 0;
    do {
        io_uring_submit_and_wait(&ring, 1);

        io_uring_for_each_cqe(&ring, head, cqe) {
            count++;

            fprintf(stdout, "count = %d\n", count);
            fprintf(stdout, "cqe->res = %d\n", cqe->res);
            fprintf(stdout, "cqe->user_data = %llu\n", cqe->user_data);
            fprintf(stdout, "cqe->flags = %u\n", cqe->flags);

            if (cqe->user_data == 1) {
                sqe = io_uring_get_sqe(&ring);
                io_uring_prep_read(sqe, fd_index, &buffer, sizeof(buffer), 0);
                io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE);
                sqe->user_data = 2;
            } else {
                if (cqe->res >= 0) {
                    fprintf(stdout, "buffer = <");
                    fwrite(buffer, cqe->res, 1, stdout);
                    fprintf(stdout, ">\n");
                }

                exit_loop = 1;
            }
        }

        io_uring_cq_advance(&ring, count);
    } while(exit_loop == 0);

    io_uring_unregister_files(&ring);
    io_uring_queue_exit(&ring);

    return 0;
}

The output here is
count = 1
cqe->res = 1
cqe->user_data = 1
cqe->flags = 0
count = 2
cqe->res = 58
cqe->user_data = 2
cqe->flags = 0
buffer = <initrd=....yada yada yada...>

Is this the expected behaviour? If no, any hint? What am I doing wrong?

If the expected behaviour is that IORING_OP_FILES_UPDATE can't be
linked, how can I use it properly to issue a read or another op that
requires to work with fds in a chain of operations?

Sorry for the silly questions!

Thanks!
Daniele
