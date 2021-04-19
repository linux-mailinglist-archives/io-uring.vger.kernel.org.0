Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E6C363E53
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 11:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhDSJOl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 05:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbhDSJOj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 05:14:39 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B961C06174A
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 02:14:10 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id a18so1781529qtj.10
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 02:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=reduxio-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=lk9G7TpP51+hD8c7SRRqP1+uQAGcpJTJnNllkqfHvOU=;
        b=zH+wrBApGX3itGsjN+iGFjOoh3QsdEbVk2IGMkjw+KR9nvnKUe5wEjzOb/5ZQaAJl7
         3q7p/MBqLW3Hkoyq3xEHYh1n4JDD4BddGs0ruur1sVb++M45RSvLxMICV2C50SBxQDUh
         kAY9YFSySPDATGsCkqEyZGUNeX532/clkzAHB/925k0Z9pUJQTzi5TwghHfxswR+Sye7
         Cs8JliT8vsDzHVhqChz3h1pUVMriMkpPXH56rpDkFG1GmULu31nasITcxUVk7Es7g1fP
         DcUaGciVNeD/7Y4/DK2LD3pvEtD5UkJJ6SM40XgWdlwz/AAAVLDpj3Fude/op3HfNmIu
         2t1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lk9G7TpP51+hD8c7SRRqP1+uQAGcpJTJnNllkqfHvOU=;
        b=QK1PFlFc/Msc1hBoPW4RvQcIKrYjlXlIAv/NZbKxcJvbbZgUhbai2v9JSB3b7L8FAY
         T1yFBr+iD5CPSzLCSNNNJtPZOu9eh26FYFfQZolND/P7Lr0+ebQipq5UxW4un2UCvjcN
         qhJoZ4dI7mV3ke2wRYtK4MH8TQSWLuseOvb7McTJ0LIPEgRzBIn6MhUoCKLtLR3DkeKF
         erFj0fYPT3qpb36UgzgeDru92MaqAAKkfSfIm+CrWjczqGhn6cmZ9AKyj/hdpcJZH5ji
         MnoUNEdJOLKGBRpAlR8u1J/uFClYsq8I3A4ZaHUzyIMWivFtPaGDyOc1sK2UHsgom94h
         aQSA==
X-Gm-Message-State: AOAM533P+Cc7UiVGLQeOjlCIEKN6GcTNPgl7InzIk0s2TLWsvUKg7CGD
        354aoguGxsTQ9CNBVCN61PcQAU8ZVeNXT4uUZoIMDQZ3VKg=
X-Google-Smtp-Source: ABdhPJzIPlm19946gYoqTxzG//GWWOh1d4GRN0B2CfWgZaGz5VTE3DMKQqx9QJGszDXL8qrn8W4r0HYhA/K5/fV41Ns=
X-Received: by 2002:a05:622a:1454:: with SMTP id v20mr10601921qtx.372.1618823649346;
 Mon, 19 Apr 2021 02:14:09 -0700 (PDT)
MIME-Version: 1.0
From:   Michael Stoler <michaels@reduxio.com>
Date:   Mon, 19 Apr 2021 12:13:58 +0300
Message-ID: <CAN633em2Kq-F_B_LPWWDpadTYbetRsf9q4Gy6nFgM8BujSueZQ@mail.gmail.com>
Subject: io_uring networking performance degradation
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We are trying to reproduce reported on page
https://github.com/frevib/io_uring-echo-server/blob/master/benchmarks/benchmarks.md
results with a more realistic environment:
1. Internode networking in AWS cluster with i3.16xlarge nodes type(25
Gigabit network connection between client and server)
2. 128 and 2048 packet sizes, to simulate typical payloads
3. 10 clients to get 75-95% CPU utilization by server to simulate
server's normal load
4. 20 clients to get 100% CPU utilization by server to simulate
server's hard load

Software:
1. OS: Ubuntu 20.04.2 LTS HWE with 5.8.0-45-generic kernel with latest liburing
2. io_uring-echo-server: https://github.com/frevib/io_uring-echo-server
3. epoll-echo-server: https://github.com/frevib/epoll-echo-server
4. benchmark: https://github.com/haraldh/rust_echo_bench
5. all commands runs with "hwloc-bind os=eth1"

The results are confusing, epoll_echo_server shows stable advantage
over io_uring-echo-server, despite reported advantage of
io_uring-echo-server:

128 bytes packet size, 10 clients, 75-95% CPU core utilization by server:
echo_bench --address '172.22.117.67:7777' -c 10 -t 60 -l 128
epoll_echo_server:      Speed: 80999 request/sec, 80999 response/sec
io_uring_echo_server:   Speed: 74488 request/sec, 74488 response/sec
epoll_echo_server is 8% faster

128 bytes packet size, 20 clients, 100% CPU core utilization by server:
echo_bench --address '172.22.117.67:7777' -c 20 -t 60 -l 128
epoll_echo_server:      Speed: 129063 request/sec, 129063 response/sec
io_uring_echo_server:    Speed: 102681 request/sec, 102681 response/sec
epoll_echo_server is 25% faster

2048 bytes packet size, 10 clients, 75-95% CPU core utilization by server:
echo_bench --address '172.22.117.67:7777' -c 10 -t 60 -l 2048
epoll_echo_server:       Speed: 74421 request/sec, 74421 response/sec
io_uring_echo_server:    Speed: 66510 request/sec, 66510 response/sec
epoll_echo_server is 11% faster

2048 bytes packet size, 20 clients, 100% CPU core utilization by server:
echo_bench --address '172.22.117.67:7777' -c 20 -t 60 -l 2048
epoll_echo_server:       Speed: 108704 request/sec, 108704 response/sec
io_uring_echo_server:    Speed: 85536 request/sec, 85536 response/sec
epoll_echo_server is 27% faster

Why io_uring shows consistent performance degradation? What is going wrong?

Regards
    Michael Stoler
