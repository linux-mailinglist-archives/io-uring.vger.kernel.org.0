Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DFD1C408D
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 18:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgEDQzE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 12:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbgEDQzE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 12:55:04 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC38BC061A0E
        for <io-uring@vger.kernel.org>; Mon,  4 May 2020 09:55:03 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a31so111766pje.1
        for <io-uring@vger.kernel.org>; Mon, 04 May 2020 09:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=3IEjuOBODdk2Rjl/1gi2rAaIDmjEsaJ9Uq7ZKWvXoRs=;
        b=NPgWvzGxn+kExU4knY5QP8mrpyzg2RGspQWFWqh+emjzja540dBPAVOuMDZsZWQDMm
         37GIYJd53YMSVlx5pkMUqpXnhBTog6ckcsbSElNrEObszSkee/DBLWdeCpQGHTQSbRiY
         O3hQwYY50KzOOEVdQi6NfZT0SCh7/Di4hlksa6mjDAgRixvVvWtiDtty9SODmCdZZrUY
         Q9+F2rvxVyi40mE2plIpeI3N6x0N7d6wRRrXO0m8pHTtQCy0XxB+X7/H+Z7jXEU3Frlj
         58XVPzfIR4Ht7ymfcZ3VVmcrhPGwTUy8dG8lbbBRK2HeM2R7CIm3CSrGbbW/zvtt1gdR
         sd2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3IEjuOBODdk2Rjl/1gi2rAaIDmjEsaJ9Uq7ZKWvXoRs=;
        b=HQKJFyZHl/80hdXsAsrG6XDFXCqUR+A5DoR9Yb25yOaYuZ+ktpwf3YuQ6o2Rnzr3i2
         Wg/238lgDj4UfQnAsy1AzT08l6WXJmlripRCJBedLZ+9//3ajjrsNmWiM+DM+FrOlczQ
         +JbFlIsyIMPDstSzKob6lfPFIKDTxe2QP/UYQCBl9bFIVxySDngYB/GyTi9sVvDX3gMX
         pkfhOLJdn666Iy4I+ayledDa7x4Mmc2BvicIh9k+xbs2mYGH/5CGNFtQNmxh35DHYr/M
         FYbbwXk7rIQymcK05sctVqylJ6DDUocgNLHwuHJt/bxw1VO6KzMWTsuY4A64TAW809be
         gptw==
X-Gm-Message-State: AGi0PuYgPYxEFBwWlkS42SFTc+mDN4HlJlASW8hrd811IkAjXBp+gMuf
        xaC68l31BW9hLGdb3k8OAIxBA7XgW8Pig8HhUzSknd0Es38=
X-Google-Smtp-Source: APiQypL77kXwkNU4fIzCvFM1tfQBxs/ZVQc+uLUezRXYvL1JUdSXpqaKcN6BmOGP/fMEt7La2H6byhEFS7tJBfEXc68=
X-Received: by 2002:a17:902:8e8b:: with SMTP id bg11mr108055plb.139.1588611303039;
 Mon, 04 May 2020 09:55:03 -0700 (PDT)
MIME-Version: 1.0
From:   Lorenzo Gabriele <lorenzolespaul@gmail.com>
Date:   Mon, 4 May 2020 18:54:52 +0200
Message-ID: <CAC40aqaSBwdBxQOn1T_ihtB=TnNLH91_xy05gFhvOG+3i3=ang@mail.gmail.com>
Subject: are volatile and memory barriers necessary for single threaded code?
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone,
I'm a complete noob so sorry if I'm saying something stupid.
I want to have a liburing-like library for the Scala Native language.
I can't easily use liburing itself because of some limitations of the
language.. So I was rewriting the C code in liburing in Scala Native.
The language is single threaded and, sadly, doesn't support atomic,
nor volatile. I was thinking what are the implications of completely
removing the memory barriers.
Are they needed for something related with multithreading or they are
needed regardless to utilize io_uring?
Thank you very much.
Lorenzo
