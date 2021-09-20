Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FA6411568
	for <lists+io-uring@lfdr.de>; Mon, 20 Sep 2021 15:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbhITNVn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Sep 2021 09:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhITNVm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Sep 2021 09:21:42 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46738C061574
        for <io-uring@vger.kernel.org>; Mon, 20 Sep 2021 06:20:15 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id v24so61291315eda.3
        for <io-uring@vger.kernel.org>; Mon, 20 Sep 2021 06:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eZ2WF2gV2aGnIBBpUi0O1vukf3SdptjUM2m7XkZt0oY=;
        b=esRI9Dxy1FXXBI8C5YJI3e1N8K2LD2DRj7gDLJU6DwBTuEOJqaLKyplPf3QcjJrTFk
         ZsYvR9tBCGwjHu1JjAXjOJ91Vn9247eS4YuqfIjZ6D3wrZCpNth4qCQp273dZUxALnri
         c6jCjTh9XX3XKCPH/42ZK2vJ390c8MryI0KQGNj5ns/K3eMnOoWLSVzsDZ3jHbeYFSuG
         fp5bJYtP5z1Y8fHGJEHVa152GBJS5LzTLou9vA/bjfBzPLy5K71PPyRQ2eUkZBFYlsIT
         DaL6LxJ2kLC9WD7FSOu1hZ4iTfWwQcD8PrLk64jT78ws65B3q0scWUsHr30fYCKEeAza
         5JWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eZ2WF2gV2aGnIBBpUi0O1vukf3SdptjUM2m7XkZt0oY=;
        b=xa8ZldVVY8hnHt5NEjdfm6KpOZjPmPxuxCN6u1xBlke2U3dbdFHMjl7KshHrJ0wR4y
         TjtjIg7FilzDrxyVPLYvPCfHRpR4PBuklIcDrGKVnktYr39e+k2WqRhExTQZDfwPVYzj
         gnn8kZd3P3KeqHW+hXH2eeZLy6a7hVqpJkR9s4YuAu7g6738/FGl2E66QmZSCrE5VBMc
         zdi4Y/mp2TKqEVle4vWZgWVvJnFOTbEa5diRZbN5kYp0x/9zzklMX6b99qqqQqb5we3r
         Fhp6pKuBaSAmwTbjRuIaOSU0VbYPRKz6Yt0Ajiewth4wvr37Yoy/zlxBoacfy7SFZg2F
         Uakw==
X-Gm-Message-State: AOAM530hRemAZA1nusXjLW4onDaD35F+WojinihXKTXK07i53E9QJywz
        9WB9hKPbq54iq1w1oMSRBMzhhOjhRZat4r5m2vN2vhceqAexnQBb
X-Google-Smtp-Source: ABdhPJzfdzu7lqkZpgbBa5HlbOsuGazBQaY+VZqrykgflCcOVC3LqGtSh/5IofumzMgljz9C69aHJNLSwuf1K1iDVvE=
X-Received: by 2002:a17:907:7613:: with SMTP id jx19mr29383832ejc.453.1632144008985;
 Mon, 20 Sep 2021 06:20:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwgayosM7YgPo=OWOG=+RcuYZ7xksUQcd03uOw-RKhxTwQ@mail.gmail.com>
 <D4F0F5A6-736E-4990-A449-0FFB7F505CCB@kernel.dk>
In-Reply-To: <D4F0F5A6-736E-4990-A449-0FFB7F505CCB@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Mon, 20 Sep 2021 14:19:57 +0100
Message-ID: <CAM1kxwj0_j4=+8gx_aBT=dv+Zr2fk4b5kdULh3=f2YhN8uhbEQ@mail.gmail.com>
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> > i just tried this patch and same failure. if you intend for this to remain
> > in the code i can debug what's going on?
>
> Yes please do, thanks.

scratch that works great.
