Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A54236F574
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 07:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhD3FpB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 01:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhD3FpB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 01:45:01 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E230C06174A
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 22:44:12 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id i4so44066608ybe.2
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 22:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=UegiCgM61O59Fpbkl3MCSV4dP1qhCw5bzv4wFI6/wbw=;
        b=s5ATRlCiEE7Tyv4sBioTQTbnDslz1aZW1gcyoZnH4D3NHeFaPNjJbAasd0NvqOhquB
         5nzp+lqXeh89t9WHRDGIWupbdgAS6D8Bm11wnbyVaRCNuMQHSjY5J7rj6fIaB8yzIurV
         CrFul6yJP0ElMLlOnhA2xRYqeinTO9HKTHq66XwqBw+kQvPKtT7g4yFuBcM5KzOi9wzI
         IWd5X+zY8Qf7WcH6+a0jy2o32R5/rqlfhlaaQ/9CGUkwWxn+u4HljLxfAA07rTpByGSW
         cK30DIMWiEnNqkb7mO+RMZBtMGLeWu3rw2Swd4MuG4dmso3DGhP5TOTPjaylYlFJOtzH
         XVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=UegiCgM61O59Fpbkl3MCSV4dP1qhCw5bzv4wFI6/wbw=;
        b=SyY895gY90VGe8VxGtD3pizqVb4yRE/I0bnJDHZ+j2Z74BO6t4tL9VLAJsRhvdeh0G
         GQ+YBJpEh0V39pT/vfp3ZRMozlwVeU1wtcsJKvlgudCo1uE7ZUXgU/PYbietmQEHeWZV
         vtRVuoki9yuTA9ANkPDNCrsJxCHj/nlj32K8B/tvX4kUiD09uhl+lQLeYlIorfh29t1I
         w2GriBxmCXhvL/BqYrGCX1jV1GqCTCE7L68VleCa61GBz+kclBk1lYVmw0IEpwsOztjJ
         s3kgOmCyvDDnPkx9O8dtVEWTynyIQo1Pp0WqHEotixrP0CF72a/nrV0IR9YD46eWmBNT
         DsBw==
X-Gm-Message-State: AOAM533QB/Xakx+jlmImOvDtaVdjd6k/81PNBEeSW/maLKSFyIhHmw/Z
        OA2LGksVGRcs2aPbKVdY7eTSaW1PIM0X0KTO3JyRZbduNdTjhQ==
X-Google-Smtp-Source: ABdhPJzg7MOb4+GKZeS907KHGaZPDfay9484Jk0JBtppSA+gJs5xwTPVeMe54HAKnfoFPeBaEOoKpNaVj3fV86HeCRI=
X-Received: by 2002:a25:bc83:: with SMTP id e3mr4573701ybk.487.1619761451540;
 Thu, 29 Apr 2021 22:44:11 -0700 (PDT)
MIME-Version: 1.0
From:   yihao yang <yangyihao1992@gmail.com>
Date:   Thu, 29 Apr 2021 22:44:00 -0700
Message-ID: <CAKVAn+CUffHxN3XTTXjOHJvfXaz0KCzp-XKFq8iY7kX0wHnvKQ@mail.gmail.com>
Subject: Wired result of OP_RECVMSG in EC2 environment
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi folks,

Need some help on using Liburing 0.6.
I am trying io_uring in EC2 environment (kernel version
5.4.95-47.164.amzn2int.x86_64, github
https://github.com/amazonlinux/linux/tree/kernel-5.4.95-47.164.amzn2int).
The test code logic is simple. I use one uring and two threads.
One thread is continuously submitting nonblocking recvmsg from a TCP socket
          struct msghdr msg;
          struct io_uring_sqe* sqe = nullptr;
          memset(&msg, 0, sizeof(msg));
          msg.msg_iov = iov;
          msg.msg_iovlen = count;
          sqe = io_uring_get_sqe(m_ring);
          io_uring_prep_recvmsg(sqe, sockfd, &msg, 0);
          sqe->user_data = (uint64_t) context;
          int ret = io_uring_submit(m_ring);
          if (ret < 0) {
              GLOG(ERRO, "failed to submit io: %d", ret);
          }

Another thread is continuously polling by calling io_uring_wait_cqes.
          struct io_uring_cqe *cqe = nullptr;
          while (!m_stopped) {
              int ret = ::io_uring_wait_cqes(m_ring, &cqe, 0, nullptr, nullptr);
              if (ret != 0) {
                  if (ret != -EAGAIN) {
                      GLOG(ERRO, "cqe wait failed: %d", ret);
                  }
                  continue;
              }
              ::io_uring_cqe_seen(m_ring, cqe);
              void *ctx = ::io_uring_cqe_get_data(cqe);
              if (ctx == nullptr || cqe->res == 0) {
                  continue;
              }
              if (cqe->res != -EAGAIN) {
                  // For some reason, randomly I will get EMSGSIZE or
EINVAL. Retry on the same sockfd will succeed.
                  GLOG(ERRO, "cqe: %p %d %llu", cqe, cqe->res, cqe->user_data);
              }
              int err = (cqe->res > 0) ? 0 : -cqe->res;
              int transferred = (err == 0) ? cqe->res : 0;
          }

Would like to know what could be the reason for the random EMSGSIZE or
EINVAL error (see comments above).

Thanks a lot.
Yihao
