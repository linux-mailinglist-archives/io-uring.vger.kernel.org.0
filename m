Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C402465A3
	for <lists+io-uring@lfdr.de>; Mon, 17 Aug 2020 13:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgHQLqz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Aug 2020 07:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgHQLqw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Aug 2020 07:46:52 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789AEC061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 04:46:51 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id e5so12078270qth.5
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 04:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=GhBfRrGgXhaQHbJXqydBfc7KMJG9fy847Y+Y9OKqvHo=;
        b=Onuq4kv4I8cHaoxo71AGgoOfecujaozzTJeXFqg728rpdYT2POGn23pnm5I09si/Nk
         662sxJqo5P+bDpI8N/h1IoQGcZ+BhgN9Ae4lJf5jZmVLH+CrulZq8Ku5HixI1YbAQUj/
         TXRtceXXNrSrii0S46Hpj8UCMqMDkQ2PGu7Vud9dWVGCUAolbJoQmwKsvqR5RTHnsfVa
         kSTCTPFESs/KT31AgmVovAA/VcYu96tYwF1b6HNAlEgvW6+cIjPpD1f1Fe5Q7cmmmWIg
         NnMsDJHdNI0ULhkNdjvT/gv/Ki0JCoJmkxc/zHCtuivo5Hi4iIHv/QLmnTEv9eac0bQ8
         FL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GhBfRrGgXhaQHbJXqydBfc7KMJG9fy847Y+Y9OKqvHo=;
        b=rHGdS2VDlUwNll5bLQCVRdKrRpNs6wUlsSw2P8w6mKymWJxlu3QE183KBDAW6C2DoN
         mdmwzdwCSu3GLRrEvAewa1eFAUMzlBniwB5ggaw4NsWtRgBn3Q6uw0Z8b5lYFtr+uKJB
         PfkwMSMswjXtc7bwv8Bs8b9p3vFmEj6V7pMcbwP9SauyezKR/eQfUYwFnfba7Z1Lzp4i
         o+tJrP6f9973wojroYHrLyfeFGs4ZiSwdwXTKzFjbRFrUXrBEvFXQ/Z6fYRBsdVBytg7
         KsnmB/3Fff4ESMoguE1Z6Ioc2sKICHUD+OQMAu64VbGdAr6UvF5gZC7EoW/QpigL0ByT
         2X5g==
X-Gm-Message-State: AOAM531WjajpXejJ/MAnXM4UonGx306oJj6hOMvOJL2AVEpyRZhddWwF
        2ea6Psv6UaNTDGWQ4wBPA8fdXqSZ+8G8NwbxthHwiOXfPqA=
X-Google-Smtp-Source: ABdhPJz0rt4l/T762dpdXMtsnSyQiz2c4LRokuu1WhWydsDPutnIQFLiGkL5QG+1cwB9cfjsNpB24538kdY2WjzLk0c=
X-Received: by 2002:aed:36c7:: with SMTP id f65mr13252918qtb.39.1597664809949;
 Mon, 17 Aug 2020 04:46:49 -0700 (PDT)
MIME-Version: 1.0
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Mon, 17 Aug 2020 14:46:37 +0300
Message-ID: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
Subject: Very low write throughput on file opened with O_SYNC/O_DSYNC
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone,

I noticed in iotop that all writes are executed by the same thread
(io_wqe_worker-0). This is a significant problem if I am using files
with mentioned flags. Not the case with reads, requests are
multiplexed over many threads (note the different name
io_wqe_worker-1). The problem is not specific to O_SYNC, in the
general case I can get higher throughput with thread pool and regular
system calls, but specifically with O_SYNC the throughput is the same
as if I were using a single thread for writing.

The setup is always the same, ring per thread with shared workers pool
(IORING_SETUP_ATTACH_WQ), and high submission rate. Also, it is
possible to get around this performance issue by using separate worker
pools, but then I have to load balance workload between many rings for
perf gains.

I thought that it may have something to do with the IOSQE_ASYNC flag,
but setting it had no effect.

Is it expected behavior? Are there any other solutions, except
creating many rings with isolated worker pools?
