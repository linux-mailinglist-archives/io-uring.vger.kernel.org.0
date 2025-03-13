Return-Path: <io-uring+bounces-7074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F60EA5F707
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 14:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C11B2166CD4
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 13:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DEC6267B0B;
	Thu, 13 Mar 2025 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="Qe/3eXMb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D616F266EF5
	for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 13:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741874172; cv=none; b=itz58hP/uPcg34QUqyF77y0kKDk0gCbEeine/RBEEtCgVSQMWjlHeRZbr8h0vimQSHe/XyAUQIQaClkf2r6ZH4i09xkwSSXpT++fAZ+yxe03xmrdJ0SZArAP14wZI6pbfY8AbUYHfFUW0DwqYB1RkwlNBK/b0TrA58tcTgJXIb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741874172; c=relaxed/simple;
	bh=OXZwBbGFVEFD60c57eDI5cj9JWNWhkxbptmsSKbkSJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CA/Y53efoAw52ow3fJaX8yjys1tCts+Pht3SmFSdZ85GhMDeUKlGHQXKyYuYgifu/01bqXc8n/hDI3IRmyB6VGL1rBaz7sqbJDSw/Uys+7TWnp+/oy0Qwc+FKVjZihQZDENhQr9WcBBSX14Gf/kzAAEHEqy42YUBpsYhKJVe6nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=Qe/3eXMb; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2255003f4c6so17581765ad.0
        for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 06:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741874170; x=1742478970; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mJWf+2Kk9KeIZXFG3cJ7oE/X0yoKG+h9t1wBj4fhOuw=;
        b=Qe/3eXMbVcP6ytBYJ76iyF11ZFTjzxBwTRc09YSXvuRg1IYxHKQgV14nktetSYpSH7
         adaS39IwuERhNLr8a3010uqOF/ybTM2gXqB3OPhSOH16cHJ1N4Wak4de26b4imXn8dpF
         T6z7cDBgj4ZWNP2DJzvUoVzYv7KUpukZTewf1HR9j7GW7VgbD7WYqzlzcOXllKG070QI
         r4hVG4okhyBmRCTh4TWudn4gX0zAIjmvDQxG/fSCo3ZSm3tLHGmZSLs6FZMuKcBZznq2
         SxoxHJZBOAwkBtH8O0gsnm4YdLhiimO5OPLztXLM57gvqyNLgFwE+DJ7jjbOl575Np6/
         CCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741874170; x=1742478970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJWf+2Kk9KeIZXFG3cJ7oE/X0yoKG+h9t1wBj4fhOuw=;
        b=QycPM2fafcDV0RQriUPfaSleMp6PoVm+NCv4qW+8iAoRe0J1yYryvP9ASVaSeubIvp
         1ZWVuFwKQ2lvDSPVJ7NRXbt4YnXNJ2WtzIC8TNC9TALPZm3KLsVMF5fz2bJ0dw8J72YG
         CDqHLo9npoADrl8B39OyxHuoKBO180xbMNABhGANmT+RZ8ACKT+cPYukzfv8HhVXgts9
         lDAqPJHRf5QptFNx70I1IYhgNcFq88j8a0QuPlufsRMcv1EsjJr/Fz2RL+nnEa0d+clU
         cheuOiZnhV8MoQN1iMTHDYfAg8C5+r2fLd403Xx67CYzAkdXxo8qnun1EbL5mWRhBdqb
         c0wQ==
X-Forwarded-Encrypted: i=1; AJvYcCVk5AFMaeaQJhOklZr6Ooz7N86eT16YyfLxvR5kWLCxT3yzZugl28pVuF6bnqB0Lz9AvsKJF74mmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyhLFeXYIuvVkcjgS66dPr/3f/EQ1eoxPtMI6SViKs17Xlb7ZWo
	0mX7QFo6P2ly55kzggbiCge0haVJb1bCM3dmPjvwGXtkdwTcSFubeyzPdxdwups=
X-Gm-Gg: ASbGnctl87xlSWFeHs+D2xhSxCuwJ4XuOkOQL6SNLYYaCsSdUxcRwtN5tZQM43ihtqO
	qvifs0wonaKiCvq6ZQcK7C9ZEzqdMllKTgn1gXYpzb4VE+NeIsDtHa1uPmlYcPK4tD9QMx2oA1E
	LqKNBxg4dNr7BLt70haNpsYVdcGQJFeJL4cxksp+SAhSau8u4YduXxxVB+aC25YMXH4rFZvho/T
	O2OnYDKNmFQ9OvRvdjX+CiSyR/Eg8mTYRonx4b6XvMLYrIklW9K9T7inh874B7jo9IpAKS7nhnc
	soGk98NrZRJeIYmSFxLGXrUCQSUy5WYuMv1tm8JiN2tvCmFG3XY546rW5go3eBTZG0wqyXfFVi7
	n
X-Google-Smtp-Source: AGHT+IEaZvgrjYn2hacXxym8AfVHesqurCWdjoDGFqV63N73+ZMsWJUmVSIvP/Ou4EEvrvg7tRtGpQ==
X-Received: by 2002:a05:6a00:6c96:b0:737:9b:582a with SMTP id d2e1a72fcca58-737009b5927mr9817205b3a.24.1741874169929;
        Thu, 13 Mar 2025 06:56:09 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7371152948fsm1365507b3a.16.2025.03.13.06.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 06:56:09 -0700 (PDT)
Date: Thu, 13 Mar 2025 22:56:02 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/2] introduce io_uring_cmd_import_fixed_vec
Message-ID: <Z9Lj8s-pTTEJhMOn@sidongui-MacBookPro.local>
References: <20250312142326.11660-1-sidong.yang@furiosa.ai>
 <7a4217ce-1251-452c-8570-fb36e811b234@gmail.com>
 <Z9K2-mU3lrlRiV6s@sidongui-MacBookPro.local>
 <95529e8f-ac4d-4530-94fa-488372489100@gmail.com>
 <fd3264c8-02be-4634-bab2-2ad00a40a1b7@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd3264c8-02be-4634-bab2-2ad00a40a1b7@gmail.com>

On Thu, Mar 13, 2025 at 01:17:44PM +0000, Pavel Begunkov wrote:
> On 3/13/25 13:15, Pavel Begunkov wrote:
> > On 3/13/25 10:44, Sidong Yang wrote:
> > > On Thu, Mar 13, 2025 at 08:57:45AM +0000, Pavel Begunkov wrote:
> > > > On 3/12/25 14:23, Sidong Yang wrote:
> > > > > This patche series introduce io_uring_cmd_import_vec. With this function,
> > > > > Multiple fixed buffer could be used in uring cmd. It's vectored version
> > > > > for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> > > > > for new api for encoded read in btrfs by using uring cmd.
> > > > 
> > > > Pretty much same thing, we're still left with 2 allocations in the
> > > > hot path. What I think we can do here is to add caching on the
> > > > io_uring side as we do with rw / net, but that would be invisible
> > > > for cmd drivers. And that cache can be reused for normal iovec imports.
> > > > 
> > > > https://github.com/isilence/linux.git regvec-import-cmd
> > > > (link for convenience)
> > > > https://github.com/isilence/linux/tree/regvec-import-cmd
> > > > 
> > > > Not really target tested, no btrfs, not any other user, just an idea.
> > > > There are 4 patches, but the top 3 are of interest.
> > > 
> > > Thanks, I justed checked the commits now. I think cache is good to resolve
> > > this without allocation if cache hit. Let me reimpl this idea and test it
> > > for btrfs.
> > 
> > Sure, you can just base on top of that branch, hashes might be
> > different but it's identical to the base it should be on. Your
> > v2 didn't have some more recent merged patches.
> 
> Jens' for-6.15/io_uring-reg-vec specifically, but for-next likely
> has it merged.

Yes, there is commits about io_uring-reg-vec in Jens' for-next. I'll make v3 based
on the branch.

> 
> -- 
> Pavel Begunkov
> 

