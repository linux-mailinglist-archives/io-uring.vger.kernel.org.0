Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309A844FBB2
	for <lists+io-uring@lfdr.de>; Sun, 14 Nov 2021 22:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbhKNVFn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Nov 2021 16:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbhKNVFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Nov 2021 16:05:41 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09070C061746;
        Sun, 14 Nov 2021 13:02:46 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 133so12236067wme.0;
        Sun, 14 Nov 2021 13:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1kCy14pWiHQLUZiqCYxumS5NGr0vdPf3t+I8K1dk1SM=;
        b=USv5uFzF44loWe33r7DI2XgFiT4OSWX5r1GSWI9VG6Otc6KbgeVe7FcaogmHQro2iV
         GqwO5f3hmfpGENPZLLY9W5xE2eJMmfJeX3lMIYEtQy/DHBmMABuzxFkhSUtH4BV/XW80
         S6C1jCbw5y7HD6w3zM2SImeJSSafkEM274od/qsd5LVCvw4ZyH66bpFcGLEDIL0/6fw2
         dthW4z1CldQzS+IXIMKvU0GMAp1iGiAlsnHNh1N7Ro2hQEcc60ihWm24WqJdgvBVejeQ
         aVKduvTCMp7i6PFl8n6DQSCu827rkEBAfUbfiqrA2SX8o/6GGhK+cueBGlRtf9xXLWtM
         fnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=1kCy14pWiHQLUZiqCYxumS5NGr0vdPf3t+I8K1dk1SM=;
        b=VPFmNRc6PszTQeqHLstO96DmZipjxmGjQm0U/nXz6qIzmv3SiTvSCSlwhdFasWA6wC
         n+VS76P2fw7F49HavuBh3dt08Q+PtYqvuDhQl7NVvZRnrqeN9gd/fWfI0zdx6P/zXOSJ
         NTBj6ymmItdE2y4Zqhu7lW9eagfb1NfxnOHs2ATLfHGnIWTx1ciLFrSgUyzvfpDubw0w
         nz1f+h7ZfaVt8dwhbYkGEIqA8TwAbJW2LLcCdGGY//hkZWWh7ObhJbUE68tcHbOHDlDA
         VX2DOXM9weeVUM/212/sIJJBoEy9k98tn0env81VWTGSM7SN4IEqSYcROOuD2INxbl/w
         Rneg==
X-Gm-Message-State: AOAM531NfVoMND6QBcXOWlzsmziLdLQooCklUaUnL8Y56emVo9Pp4Am6
        IkYluPOuqvQvEwqnYVbJ9jCb8ciLSL31Om3Z
X-Google-Smtp-Source: ABdhPJylkn8Rkgv8jlM6y7AvEhBNM6ZGbJ+xVxjllXxmCYC+caDe2HaNNj7Viu+6fBOVf6IQDjTZTg==
X-Received: by 2002:a1c:1bd8:: with SMTP id b207mr54136148wmb.114.1636923764108;
        Sun, 14 Nov 2021 13:02:44 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id e18sm12260857wrs.48.2021.11.14.13.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 13:02:43 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 14 Nov 2021 22:02:42 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Daniel Black <daniel@mariadb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: uring regression - lost write request
Message-ID: <YZF5csKMKfKBeIyN@eldamar.lan>
References: <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
 <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk>
 <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
 <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
 <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
 <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
 <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk>
 <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
 <CABVffEN0LzLyrHifysGNJKpc_Szn7qPO4xy7aKvg7LTNc-Fpng@mail.gmail.com>
 <00d6e7ad-5430-4fca-7e26-0774c302be57@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00d6e7ad-5430-4fca-7e26-0774c302be57@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On Sun, Nov 14, 2021 at 01:55:20PM -0700, Jens Axboe wrote:
> On 11/14/21 1:33 PM, Daniel Black wrote:
> > On Fri, Nov 12, 2021 at 10:44 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> Alright, give this one a go if you can. Against -git, but will apply to
> >> 5.15 as well.
> > 
> > 
> > Works. Thank you very much.
> > 
> > https://jira.mariadb.org/browse/MDEV-26674?page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel&focusedCommentId=205599#comment-205599
> > 
> > Tested-by: Marko Mäkelä <marko.makela@mariadb.com>
> 
> Awesome, thanks so much for reporting and testing. All bugs are shallow
> when given a reproducer, that certainly helped a ton in figuring out
> what this was and nailing a fix.
> 
> The patch is already upstream (and in the 5.15 stable queue), and I
> provided 5.14 patches too.

FTR, I cherry-picked as well the respective commit for Debian's upload
of 5.15.2-1~exp1 to experimental as
https://salsa.debian.org/kernel-team/linux/-/commit/657413869fa29b97ec886cf62a420ab43b935fff
.

Regards,
Salvatore
