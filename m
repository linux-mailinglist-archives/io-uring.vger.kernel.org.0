Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65A32C8E77
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 20:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgK3TwG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 14:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgK3TwG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 14:52:06 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B48BC0613CF;
        Mon, 30 Nov 2020 11:51:26 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id s21so11081742pfu.13;
        Mon, 30 Nov 2020 11:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zC0PeJkR7yCy36IMIoRn3ylAVbD/c3Hqhsk64aos3kU=;
        b=UoBa+DTqVcxdOcxlPGSuUK9E3D7O3xrRDh63FxBPASX91RL3tUZEShrtZFDkionefI
         aKhuhYBRoee9IKSh5XD7vUj2NPtSDl/aVro21fZUOxY19seMME39LCXuPSJrsPXhCJZ+
         ZsgkTGDm0vZT+1DWbBs8FIzAu5iEmBDFeX7P4bZKe1k25o09VJv8jhh4eCT5ym+YPQ1z
         v4qSQn9ZfNVciSKAm0R5yPOPqDRmQpeLO3c6O4VL7SWFqM5MhTh7B5ob+YkhzoP77Y13
         CfVfJ1zHc05s+XxJyc3LHtvn9AjD7O7qMHFxkZXB3ZEvv8CCAG/bXuJr3tnQXy4OntsE
         AWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zC0PeJkR7yCy36IMIoRn3ylAVbD/c3Hqhsk64aos3kU=;
        b=YSFdC2on/Rjuq/fHkkkNnXEq906Rjy0YZrHd3CK8kgUv4XgrECTSCY9a80wS8JV7+I
         sktY8KNbJv4xo/YHQYpp3qzi/rgcBIvt1exS0f+eOHAVJFz+5+lEvlbe/AXNbr3dUjLx
         JC7seUVA0zc7OQG3UDf6Mt7JN3/b6C4IFoll2l33PID5hqfweXkqiBGze8PmmJuIGh8T
         P5QOiswYGM1AF55bHoCSVdIuEMaibqXBpVTlL2PmeGRtJX0W33n3q1t7dnTkXu9IaYmb
         IIzdUD8EJJQuw/vEz9ByWznrgRO5ywt5ZSv5aYGX6gdhIrxCz3vzj7m4hNFpaQ46405v
         dEjA==
X-Gm-Message-State: AOAM531aBup75KLu3BjQv2kkPIbbr9wrpaUaWIdAUerVbMGR2dYcsi4z
        2Z2Ghd/KOO+jn9Fq23Df4YlfTTQ2CgMGMg==
X-Google-Smtp-Source: ABdhPJwskHEQwvWGBwIKjJoTV7ixgr4aaykyEmV7aMkRGd40AnPgV5qrzbm2wUS8p7dpBlJQlJ6Kyw==
X-Received: by 2002:a63:fe0c:: with SMTP id p12mr19495977pgh.31.1606765885089;
        Mon, 30 Nov 2020 11:51:25 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:b484:b377:b015:2fad? ([2601:647:4700:9b2:b484:b377:b015:2fad])
        by smtp.gmail.com with ESMTPSA id z12sm17727361pfg.123.2020.11.30.11.51.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 11:51:24 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [RFC PATCH 12/13] fs/userfaultfd: kmem-cache for wait-queue
 objects
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201129004548.1619714-13-namit@vmware.com>
Date:   Mon, 30 Nov 2020 11:51:22 -0800
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A0BB54C8-9A06-46AA-B336-3F0D75FD6A7C@gmail.com>
References: <20201129004548.1619714-1-namit@vmware.com>
 <20201129004548.1619714-13-namit@vmware.com>
To:     linux-fsdevel@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Nov 28, 2020, at 4:45 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
> From: Nadav Amit <namit@vmware.com>
>=20
> Allocating work-queue objects on the stack has usually negative
> performance side-effects. First, it is hard to ensure alignment to
> cache-lines without increasing the stack size. Second, it might cause
> false sharing. Third, it is more likely to encounter TLB misses as
> objects are more likely reside on different pages.
>=20
> Allocate userfaultfd wait-queue objects on the heap using kmem-cache =
for
> better performance.

Err=E2=80=A6 The wait-queue objects are still on the stack in some cases =
that I
missed. Will fix.=
