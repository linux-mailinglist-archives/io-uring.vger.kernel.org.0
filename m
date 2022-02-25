Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2724C4745
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 15:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241605AbiBYORc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Feb 2022 09:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241721AbiBYORb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Feb 2022 09:17:31 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215204FC4F
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 06:16:59 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b8so4857876pjb.4
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 06:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=YhYYsdQcONY9YRE8coWu1QboYVmf7M3G+Dh3/qRXnN4=;
        b=aNfRbSCV2oAKwSPzOihMM7ec4srpm92wWo/QL2Ns29f1lI7s6SqWRwXKqFXLDQNDMo
         5RoAUtlecEd8gNAuMDdR63EGcS298xppL53L6haWLWOdjIZCuVoDujXvmsbB/Oamhba7
         cN4rczTfF7RAFutO9RRcOeQByAFk9EENncx9nBSsaA8i48TtF+rwK+DI5oVrdk1TqalS
         +PUwjPiLiHK9s6rVoVXx0Ho29Emwp/pETgwivW0pW9KsBUbXxOTCVYag/upZ79ylrn+Z
         YPMzfUAnWfHWlACZTIzPfyFRLFgy6T5hguEKpb3gWIwsWolO6pIv3el/LdrqTHsbKh9N
         oGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=YhYYsdQcONY9YRE8coWu1QboYVmf7M3G+Dh3/qRXnN4=;
        b=MwWnWfPyt00bkgSurpE3YpA/Dkj/AMe1Gi6fUbUsKt5Fd1rGy3iHLcUHdr45qMWRI0
         FD8sv/eoU2dcX9bFCNkeOIYhi8Cbqhz/jIggd5OxQW7RbD6qD4PPvMdIxcC4KYnsqQ5p
         3y/dFEkDKeWMlpFYuh4q3Gogmxt3dqBGFdP7Bia2OnbGNBy8noO33ZKsbaLyOgmHG43y
         9lH+B9tC+s01E9LTSacWw3tRisVNsJaab8Qaeoy2QDPYbSW6isQXBhc9poUHzhFju/k0
         yRLigyDi90E+iNXQL/gZEwqxLgaiUBMUGA/BduEHHHOrP/ZLGtOk2jG5Zhg6nBwSMJn4
         9mDA==
X-Gm-Message-State: AOAM532QTgRygNv00noV4qmCDX5SrzIjbcGAWCMoOCxer/UWHfaoAQfR
        zbUVg83E/Q+LFLGTSyMuVDK1+41l8P1USg==
X-Google-Smtp-Source: ABdhPJytJ0jsGHfjOdogc1bvVxlpSppRZwEZapHzG6utp54mWhWFSB7d/Uo4tW7tHyLPD5kqk4gmQA==
X-Received: by 2002:a17:903:2406:b0:14d:2f71:2e6d with SMTP id e6-20020a170903240600b0014d2f712e6dmr7522734plo.98.1645798618311;
        Fri, 25 Feb 2022 06:16:58 -0800 (PST)
Received: from [127.0.1.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id pg14-20020a17090b1e0e00b001bbadc2205dsm2978049pjb.20.2022.02.25.06.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 06:16:57 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Nugra <richiisei@gmail.com>,
        Tea Inside Mailing List <timl@vger.teainside.org>
In-Reply-To: <20220225011436.147898-1-ammarfaizi2@gnuweeb.org>
References: <20220225011436.147898-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v1] .gitignore: Add `/test/fpos` to .gitignore
Message-Id: <164579861740.5846.9688732659758320323.b4-ty@kernel.dk>
Date:   Fri, 25 Feb 2022 07:16:57 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 25 Feb 2022 08:14:36 +0700, Ammar Faizi wrote:
> Dylan forgot to add it to .gitignore when creating this test.
> 
> 

Applied, thanks!

[1/1] .gitignore: Add `/test/fpos` to .gitignore
      commit: ac154c44e8c2d5b23017111dc44b419068c1ae34

Best regards,
-- 
Jens Axboe


