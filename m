Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E342947DDD6
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 03:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346012AbhLWCtJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Dec 2021 21:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238419AbhLWCtI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Dec 2021 21:49:08 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61912C061574
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 18:49:08 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id p37so7425854uae.8
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 18:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=jcMeKyqyA4b31y0Yd/3BJHEddtbdEh2BTdyOHm+ABFQ=;
        b=SJ3y65ISdEtpTm/qecS0g3xfNnnbRgRHYq8O5395NyuvS3q6rjNCRRoZirfv3NVLXR
         c8urbEoU9CutS4+E7m/ChMqAfd6lD+ehklhbh97m+28V2wDKqDzWsSiGipQmarvN8Be5
         83faksOZKNTJYGzp3EwuW/mouR+x+MRA7VIlU6OA9I8mND9QHeXEZgWeN8tyMv++UX2T
         mcxGV29vG7S8H7YEHQ5bxpLSPRQNgxFJiGnNgoOEH3xvhGvIVS3MiXwM4XhFEeH2Wat+
         9HZoPPA+bszQ4MQJiUjYogSEv+xAfy24hFrinysVOnl2iiNvS6iP2xPSoBb37LkkpLnv
         mw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jcMeKyqyA4b31y0Yd/3BJHEddtbdEh2BTdyOHm+ABFQ=;
        b=bCxr2b0RZMbe0IJ6OtPTuNSKeWta4ilHXk/VXVSTScrAF1nQuN+l0z/vQDKRvmIK1C
         wbOwrN8QNRA8imbwUW8EJBKtyaNVYwcePlI7aKvJwg+lHbRC1UjN4gLOzdAZ7cjgRsLd
         /YwkmLP/u7Ksh5hQeShHFJUrFjxwskeLZcDfcruitIYUUrjSJu1GQsE0oMij2q+sh8Rm
         KIyfnbCyFZ7Q3RlUmN7MJxQpJoP30qOSKSJecGkEJYYYfZnd2tWLKTh7ekrTSSLES1lI
         JJo/qkpeqyf2Lzjx40jEUDI3W+B9ZOjpiNSo6IUtMw0mtPyz3yRqp8Nmmzz/VwiGkKTI
         LoGA==
X-Gm-Message-State: AOAM530ScIKjJnO7NcayOH0MHm9c38pc1gUvA+Zl51iHmZ0byY/Etu93
        XA+anfhAKlYAZ0r8AauFzJizrKP8jlPA5eP3kEZo5Rb/qfY=
X-Google-Smtp-Source: ABdhPJzrdHP4TUA20B/YV7QZ6vgWL/7G5/PA6R2awzMAGE4KUK4BcXJ7CBWOLE0AUx733nnhOwwc1kYxlgMewdUszFU=
X-Received: by 2002:a67:d207:: with SMTP id y7mr150647vsi.28.1640227747384;
 Wed, 22 Dec 2021 18:49:07 -0800 (PST)
MIME-Version: 1.0
From:   David Butler <croepha@gmail.com>
Date:   Wed, 22 Dec 2021 18:48:56 -0800
Message-ID: <CANm61jem0rMt75PuaK_+-suX_WRi+jXPy3BqHZjAR95vzP73Jg@mail.gmail.com>
Subject: Beginner question, user_data not getting filled in as expected
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I'm trying to learn the basics of io_uring.  I have this code `hello_uring.cpp':

// clang-13 -O0 -glldb -fsanitize=address -fno-exceptions -Wall
-Werror -luring hello_uring.cpp -o build/hello_uring.exec
#include <fcntl.h>
#include <stdio.h>
#include <assert.h>
#include <liburing.h>

#define error_check(v) if ((u_int64_t)v == -1) {perror(#v);
assert((u_int64_t)v != -1);}
static int const queue_depth = 4;
static int const buf_size = 1<<10;

char buffers[queue_depth][buf_size];

int main () { int r;

    {
        // setup test
        auto f = fopen("build/testfile2", "w");
        for (unsigned long i = 0; i< 1024; i++) {
            fwrite(&i, sizeof i, 1, f);
        }
        fclose(f);
    }

    auto file_fd = open("build/testfile2", O_RDONLY);

    io_uring ring;
    r = io_uring_queue_init(queue_depth, &ring, 0);
    error_check(r);

    {
        struct iovec vecs[queue_depth];
        for (int veci = 0; veci < queue_depth; veci++) {
            auto sqe = io_uring_get_sqe(&ring);
            assert(sqe);
            sqe->user_data = veci;
            printf("submit: %d\n", veci);
            vecs[veci] = { .iov_base = buffers[veci], .iov_len = buf_size};
            io_uring_prep_readv(sqe, file_fd, &vecs[veci], 1, veci * buf_size);
        }
        r = io_uring_submit(&ring);
        error_check(r);
        assert(r == queue_depth);
    }

    for (int done_count = 0; done_count < queue_depth; done_count++) {

        struct io_uring_cqe *cqe;
        r = io_uring_wait_cqe(&ring, &cqe);
        error_check(r);

        printf("got_completion: %lld, %d, %d\n", cqe->user_data,
cqe->res, cqe->flags);
        io_uring_cqe_seen(&ring, cqe);
    }

    {
        unsigned long next_value = 0;
        for (int buf_i = 0; buf_i < queue_depth; buf_i++) {
            for (auto buf_values = (unsigned long *)buffers[buf_i];
(char*)buf_values < buffers[buf_i] + buf_size; buf_values++) {
                assert(*buf_values == next_value++);
            }
        }
        assert(next_value == (1024/8) * 4);
    }
}

On execution, I get all zeros for user_data on the `got_completion'
lines... I was expecting those to be 0, 1, 2, 3.... What am I missing
here?

Thanks :)
--Dave
