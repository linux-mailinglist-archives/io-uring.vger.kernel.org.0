Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351DE2A96CC
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 14:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgKFNPL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 08:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbgKFNPL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 08:15:11 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CD0C0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 05:15:11 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id l28so1838645lfp.10
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 05:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rui/jrkkxuCrpSSyB1pAV0V1m2gFWp15M1Wq29yAOfU=;
        b=rzCK8FVEohCqawmF23trQM6xafAFTbQ1eQvsGF5PXkXNTQh1OKsP3wt7b09DkNZUsG
         XwSVyh4E6eI9LCXMWUK8k6A/ZC7wXyTRd5YTkuigTEjjnZbhShSJK92bXyFvZc8nB/sj
         Bi4Hmg/6iMQgiqhPQx+NTdtzYOEduTwLOpApTWektd4SxG6k2BWHhvMSq8NlfDukFEAo
         nhd5qP40aq19IaMHX4DK+uk+cWFGifw5PP7WAb/ewiYlYXPzNS5qxiXdkrceEjeSMt7u
         6byKXZ68vvWw3YIYxTi/X4xPOtpj4ab0B504NPXinSPYFrajX5P2rE8Kdh9oRnIAct9e
         k+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rui/jrkkxuCrpSSyB1pAV0V1m2gFWp15M1Wq29yAOfU=;
        b=fKvBuNIx5hSJ49/fX3ZXQy8fyBXaU7N6zL2vi7vSAOdSuFKhTIRoGc0nlH/+PeAy2w
         B/p2I05UwPgPOIoWOe8eTA2gONLlXrftmxwLssqgtVpM0CuU8Z+WzCOx9fC2TRof/Vep
         pG4S2JgIHpnCdY/AIW1PE0lY+SDQlJxTkbtQq69i0ft9Fc8NUvCuKSiwZN5mWNtXjRtq
         0flC9O/pFtpdloZej1ZJLfra5lNUYR2bjpNjsEEVRrgjaguA9EZA5VY/erstvUzreUKr
         fWYdUro0zaqOq79sxp8Q/wSYdujDn93Zg2VCEcg0XzBe5VWSuZ6q6D6R1cCUPuA8HqoM
         o+aQ==
X-Gm-Message-State: AOAM5305V/7P8BQuoX07rBjkAZgz7HtwOAYpd+BKzDRVf8devEcojXIm
        FiLWr4Rz+ajKkeXbtox2DacUh97rFaOu7w==
X-Google-Smtp-Source: ABdhPJwTERrj3aUnJ71fl1uWIrUczHKJrNqqDmocM4XKPAvigi37DSCtSKBRORESp4JwSboDNvbrTQ==
X-Received: by 2002:ac2:51cb:: with SMTP id u11mr847165lfm.247.1604668509621;
        Fri, 06 Nov 2020 05:15:09 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.gmail.com with ESMTPSA id 21sm158941lfa.183.2020.11.06.05.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 05:15:08 -0800 (PST)
Date:   Fri, 6 Nov 2020 20:15:06 +0700
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
Message-ID: <20201106131506.GA3989306@carbon.v>
References: <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
 <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
 <97810ccb-2f85-9547-e7c1-ce1af562924d@kernel.dk>
 <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
 <361ab9fb-a67b-5579-3e7b-2a09db6df924@kernel.dk>
 <9b52b4b1-a243-4dc0-99ce-d6596ca38a58@gmail.com>
 <266e0d85-42ed-e0f8-3f0b-84bcda0af912@kernel.dk>
 <ae71b04d-b490-7055-900b-ebdbe389c744@gmail.com>
 <20201106100800.GA3431563@carbon.v>
 <b6e9eb08-86cd-b952-1c3a-4933a2f19404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6e9eb08-86cd-b952-1c3a-4933a2f19404@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 06, 2020 at 12:49:05PM +0000, Pavel Begunkov wrote:
> On 06/11/2020 10:08, Dmitry Kadashev wrote:
> > On Thu, Nov 05, 2020 at 08:57:43PM +0000, Pavel Begunkov wrote:
> > That's pretty much what do_unlinkat() does btw. Thanks Pavel for looking
> > into this!
> > 
> > Can I pick your brain some more? do_mkdirat() case is slightly
> > different:
> > 
> > static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
> > {
> > 	struct dentry *dentry;
> > 	struct path path;
> > 	int error;
> > 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
> > 
> > retry:
> > 	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
> > 
> > If we just change @pathname to struct filename, then user_path_create
> > can be swapped for filename_create(). But the same problem on retry
> > arises. Is there some more or less "idiomatic" way to solve this?
> 
> I don't think there is, fs guys may have a different opinion but
> sometimes it's hard to get through them.
> 
> I'd take a filename reference before "retry:"

How do I do that? Just `++name.refcnt` or is there a helper function /
better way?

-- 
Dmitry
