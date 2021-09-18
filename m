Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68364106DD
	for <lists+io-uring@lfdr.de>; Sat, 18 Sep 2021 15:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbhIRNmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Sep 2021 09:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhIRNmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Sep 2021 09:42:42 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90DBC061574
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 06:41:18 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j13so41063233edv.13
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 06:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=vKc2Ao4fxMdAR8OMZ6jinLImu79QEYOKmsJEu53F6mw=;
        b=VDrweNEFrw4eRuAWEqygxJSReam8Xg5xNdyBNR+1oW57aiN2aADyK2/sgKbd4qhDAd
         x0IXIJcollj6m6MWjjBq4091nWbu8Y86nbNfnZTKHQMxBrV6bjI8e5MjAwc6aGMhPbl/
         3/qlLFCdudZtGFklUqx3y8y0VdUHsBHkkwg2AAc/FQfeojspG+msJcveLSeIH1cecanp
         s70exRhvxPZFvu31YwGTQMmg9cuJLZ7TRyv9KBrKkZzlZRqDhHajvtk1vAb+FRw09OO6
         aw+AqJsjbuJiUGxl0QqNj9Hn2Y70riOUWL8PhJJfcs+24iNajKk9JmUckWXxr4gLdiuK
         vdrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vKc2Ao4fxMdAR8OMZ6jinLImu79QEYOKmsJEu53F6mw=;
        b=1oA/bBYzh/tCbdisKZrcw1cZBa2plB/gqxgIU7Ar1BmTpLATVWg576bwh29CqSGxs/
         PssyHsybVoZnVwRBZICU2ApSlg8N42/aw6WYnbtF8tJAyOUzxQBYRHhx8oOceP+b6g7V
         xYX3Wp9kgA7cqZg5fgnQNN+nbuvNfn62f8P009qdhVwqVmYY1y5rrVlsClzdJVRbbFUs
         yjLRZZ+4Pc2rSwbOpBVluVJqE4oQkGOlpMFmqDLjGzzI3Sgc5O8ZWV0KaG8Utf8EpPIB
         p9yJ3soi1e4C4l53PgKexAd5wKvTjsUpMh0L5/Rw+pG//6Nk00DdClI1wDk3YmcWqPOj
         41hw==
X-Gm-Message-State: AOAM530lPqCD0xKsftju8pkzVXYAIpCb3XKV0pdeYKqjugG5FREOCIn+
        U0zShIPVSDcBVyuCvEcPAEPdokfIWAq4oyCmwNOiQ2SGqe2veweP4PE=
X-Google-Smtp-Source: ABdhPJw/5tgCeOPBeFNsq43GBXHei3x1jFpW7xOLbndV6+riFNGHEHR6sm8AWSh/G/y+3kYKWO11oslofqWL1oCbxNQ=
X-Received: by 2002:a17:906:f74f:: with SMTP id jp15mr18640781ejb.423.1631972477083;
 Sat, 18 Sep 2021 06:41:17 -0700 (PDT)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 18 Sep 2021 14:41:05 +0100
Message-ID: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
Subject: [BUG? liburing] io_uring_register_files_update with liburing 2.0 on 5.13.17
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

just auto updated from 5.13.16 to 5.13.17, and suddenly my fixed
file registrations fail with EOPNOTSUPP using liburing 2.0.

static inline struct io_uring ring;
static inline int *socketfds;

// ...

void enableFD(int fd)
{
   int result = io_uring_register_files_update(&ring, fd,
                      &(socketfds[fd] = fd), 1);
   printf("enableFD, result = %d\n", result);
}

maybe this is due to the below and related work that
occurred at the end of 5.13 and liburing got out of sync?

https://github.com/torvalds/linux/commit/992da01aa932b432ef8dc3885fa76415b5dbe43f#diff-79ffab63f24ef28eec3badbc8769e2a23e0475ab1fbe390207269ece944a0824

and can't use liburing 2.1 because of the api changes since 5.13.
