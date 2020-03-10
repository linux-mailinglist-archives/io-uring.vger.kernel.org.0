Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E78117EE07
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 02:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgCJBbq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Mar 2020 21:31:46 -0400
Received: from mail-il1-f176.google.com ([209.85.166.176]:39417 "EHLO
        mail-il1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgCJBbq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Mar 2020 21:31:46 -0400
Received: by mail-il1-f176.google.com with SMTP id a14so7431354ilk.6
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2020 18:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=mime-version:from:date:message-id:subject:to;
        bh=p5YYkMfZFvxCuOK0QDt3peG3iB+AwaGpe1v6JNKnBkQ=;
        b=jGwyJ8tgzhv00CA70PmjUkppUX4F+2xDQOkr5y+emli0r4VLPqEeW5lg/gK4qoMCqJ
         0sRYmX288u01wSjb9HFsWP9cz/UvTOHbAbVObcENQ6PjC/qhjjSnlCZf2fZDSP6OJtYy
         w0d+ZkI6ho5MCgH5xDzZ24CGr6mteaHlAcPfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=p5YYkMfZFvxCuOK0QDt3peG3iB+AwaGpe1v6JNKnBkQ=;
        b=GqckgNpssHzJ8i7C7aRFD0REDB/ZNlwFcLT9mu1wa7O10kJ+bmOMVKsDqaeMDJJzHI
         KDUb/tbTd8uLFSlzMf0jLQNXCWD7VtpdZpJeUL0s0oFVMShZnkV8wDqwfRvr7cHScNa8
         ZVRoXkJKRRE0kFTR3EFW4SJ948nYK6Gz0x877qQwzubSyP1iLDQxOJRoEUKcigZ48R05
         hhXl0OJ0YfOWHt6a6/zxg8kucOUWDnIT//l8HtbYEVF41k6QodKQyt70e64cxQBDkNoH
         1eTOjI4ksq3fyIeL/BPV6mDrSuJmdHmKblT7AeVMOM4hAsV9jjc61/ha2G3sJ+3d3CV8
         xCtQ==
X-Gm-Message-State: ANhLgQ2kEWNG6GcnftB5frO38/7V667wrrRtjJKZy3SMtvkWIQyHgkJt
        kvNU7Y27unRjfmXtQj4F89FRSbylGq7eP4IdCrUi48XZ
X-Google-Smtp-Source: ADFU+vsrBV1z/FdDfaA0lT/D2bLJWov2kR9Z4yUbMwbFTDvRZ6jhjJAF3jl+PqkOC3JaxV8jmeRXyXTBzkbKPx6mX6s=
X-Received: by 2002:a92:d9d0:: with SMTP id n16mr7813612ilq.200.1583803905350;
 Mon, 09 Mar 2020 18:31:45 -0700 (PDT)
MIME-Version: 1.0
From:   Ashlie Martinez <ashmrtnz@cs.washington.edu>
Date:   Mon, 9 Mar 2020 18:31:34 -0700
Message-ID: <CA+KEPO_-7woKF=eNV0jnuT+JOFW43im3dxzZMJTuPbSns638pw@mail.gmail.com>
Subject: fsync with SETUP_IOPOLL and SETUP_SQPOLL
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I am playing around with some of the newer io_uring features on kernel
5.6-rc4 and I was curious why fsync always returns EINVAL when the
SETUP_IOPOLL flag is set when running on a file system (in my case xfs
since it supports iopoll). Is this because you expect all changes to
already be persisted on disk already? Do the assumptions change if for
this if one is using a file system rather than a raw block device (ex.
would I also need to use O_SYNC in addition to O_DIRECT at file-open
time)?

I am not super familiar with io_uring and how it interacts with file
systems vs. block devices, so any insights would be appreciated.

Thanks,
Ashlie Martinez
