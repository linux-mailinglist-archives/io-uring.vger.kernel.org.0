Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA82D5758E7
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 02:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241086AbiGOAzM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 20:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240865AbiGOAyy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 20:54:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4EB1090;
        Thu, 14 Jul 2022 17:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SC5STAxYMrLw8OuznMuUxETRPPpQbdlO5stq5P8p8NQ=; b=XeT7xlTsnbkbjN3XYwyUqJqjeC
        t0ZfCezg+IU7zLI+B4m+UwgbWyX5RF8ArMZyA0HkVKTEzJX9wMiVx++3Br6tn26dYpshjzn0bn3lT
        jCzOoQ5DxUN3zx1hk2mjZfvWlZYqZFX/rDJCNU759w//Ag9JDcan1UjEPzFSjmydfKDnnKvY0v6tz
        f024CNCGDNh9UZ0+1qTI9pqMaGczJTA/4pL5Xyuotf7B7+VuMRXl3BEG7Ros79m90YE1gwrwKGjy2
        iL4dHw9bY9fXjxUdAFdQJGwcPx/Qn3qW/BuzOi6CydgqPp3w1OVvTw52K1gP4CAkgq8mByvHGyiY4
        XGPAUrSw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oC9b7-002uuK-5W; Fri, 15 Jul 2022 00:54:25 +0000
Date:   Thu, 14 Jul 2022 17:54:25 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     axboe@kernel.dk, paul@paul-moore.com, joshi.k@samsung.com,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd
 file op
Message-ID: <YtC6wT4CYq0an/vX@bombadil.infradead.org>
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <30dee52c-80e7-f1d9-a2e2-018e7761b8ea@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30dee52c-80e7-f1d9-a2e2-018e7761b8ea@schaufler-ca.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 13, 2022 at 05:38:42PM -0700, Casey Schaufler wrote:
> On 7/13/2022 5:05 PM, Luis Chamberlain wrote:
> > io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> > add infrastructure for uring-cmd"), this extended the struct
> > file_operations to allow a new command which each subsystem can use
> > to enable command passthrough. Add an LSM specific for the command
> > passthrough which enables LSMs to inspect the command details.
> >
> > This was discussed long ago without no clear pointer for something
> > conclusive, so this enables LSMs to at least reject this new file
> > operation.
> 
> tl;dr - Yuck. Again.
> 
> You're passing the complexity of uring-cmd directly into each
> and every security module. SELinux, AppArmor, Smack, BPF and
> every other LSM now needs to know the gory details of everything
> that might be in any arbitrary subsystem so that it can make a
> wild guess about what to do. And I thought ioctl was hard to deal
> with.

Yes... I cannot agree anymore.

> Look at what Paul Moore did for the existing io_uring code.
> Carry that forward into your passthrough implementation.

Which one in particular? I didn't see any glaring obvious answers.

> No, I don't think that waving security away because we haven't
> proposed a fix for your flawed design is acceptable. Sure, we
> can help.

Hey if the answer was obvious it would have been implemented.

  Luis
