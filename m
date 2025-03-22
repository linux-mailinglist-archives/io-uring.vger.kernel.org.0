Return-Path: <io-uring+bounces-7203-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A85A6CB28
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 16:23:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04D23165E52
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 15:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2819522F3B8;
	Sat, 22 Mar 2025 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="NBHLdxrQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1B429A9
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742657011; cv=none; b=KgpqprPssLhDBlSqhC9gaVsTuZ/pFRLHbAyENgeY2898hPtGxbvquYwmb57hBYBjyrFsvH/Vc5IiFstRISEzqul2g4iDJqJ5PHd200QeDn1RTdZGqd+yvFl7VyWnFBT4gsWMrT0qhcMzFBNFMWWGF5/AN/9XEqN44znM+XlkSZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742657011; c=relaxed/simple;
	bh=ZOLy9kblT2spyGdVbM0xvXGE5iqNq/8rVxdRzpJrNm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bh44Ceuvnajdt4n8XYOOLJ1lYc6dxC305q8z5oV0+PUCddBodwXK+FEn6M4TJtn5J6N1R6RENnuHzPtGWleqlRs+5vPzd2WdsPDBqXaNEaUDwARxgOO3+8/CXKpklDnS2I8E0sq7eTP/ce11gqOV8KAv6ygBdzyEEL29XpLS+SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=NBHLdxrQ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2235189adaeso56019505ad.0
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 08:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742657009; x=1743261809; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=61HK6RXVqW5ScgZIgBIAV/0zJZv4+R6BdiaVkC0uX+0=;
        b=NBHLdxrQSDA1veeJskmGFA4tnIn1VAvUeCf81NKxMAHrf9HIWSYcdOKWWozYwSUf8S
         PnRe2giNqjX1Tb/xdoF1qT3UOWYAHa8zHwh0HqztxuleA2EtXOfuvdKVCh+Xk2BIQ7Ri
         HRkk23CQGtBQGAIMOK1MYUh/68T/1hrjH7VmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742657009; x=1743261809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61HK6RXVqW5ScgZIgBIAV/0zJZv4+R6BdiaVkC0uX+0=;
        b=wDvz2Z+yxgeqwmgJluob2QYPo4juG1Sia9gycsGGOwEBxKYr4tgSOQxaWYuotQub67
         REA+Mwx3jKT9fz0UFys0ULE35bFS6iX1V2Z5F4aNtXpKeJX1tTaPAaKa7BYeeT5x56xk
         b/Uw1TjrEyR2oMjsCDJ89aUgnJ3hN7FWDLorrxL1EEgWidTRsFARCMQBG75VcapqbWYA
         I6mqez6FnIoCHB5+drEgvRiYCTy1qzRZfimCIhhWhFpvsDAVNDPHqxNa74KyQBNgCBwZ
         tgn+LxwnzshcC1BdPmxu9YrCO/5kxG20cbp/8pkEbdMGjZzj50VcPVDsRncAGuGSFaPf
         WCHw==
X-Forwarded-Encrypted: i=1; AJvYcCW4Zy6fUdeUH/o52wQ24IR6ui3WHea+FDM1WRj2pGlpGzuvnkT2vPXTztYmytta1SUOmYoiPnx/gA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQwAAYOEvyPs8WQ/6wbRUKnLgcrhtrWcoDi09hjMnPqpDJRWtF
	WLNcPRx9/bZQmFiiK7rDPAOpRv8hJ8cIGy124Gk+5esZnNox2US64/+TDbLZMtg=
X-Gm-Gg: ASbGncuTE/OM2bdOhLkEewU5FtCJcP4jKJd/JYHTABrgKXoUMjOsBRLfhsr2OiW2dTs
	+LZXn4LMstjca50w+BdFZ7bK9LkFNwSIRbscFKO+9WalzJhNNUvRw0ZluZsz1E8J18D09G/G6th
	oOYD1KVypE5rPkhfBk1qG8ImcCKU+TFvEJGX80KOrJqy8wSILcmk2LbRR4jqruopqiJ88g/YpSl
	jsOb98ZulLyfouS9Z68PO7O4Acnqg4xbIyZtUnlGUIrtqsVMEwG2ktV0iMtXxIQbc5scsRTpSPl
	npefyqZpF8qw96QuQVy0L8stk5eM7bu8gwZ/K7pWGqcXuIhEWZntWPCIlOh386eWUz8el3QPthd
	l
X-Google-Smtp-Source: AGHT+IEAFSoC4sIeZaO2AHNlHse9aa5cT0YNBzdKy6xktGy4qrSSxCmk5pb4vRu9mOnEB+PXHQLSYg==
X-Received: by 2002:a17:902:ef4f:b0:21f:1348:10e6 with SMTP id d9443c01a7336-227806cfff4mr130234545ad.13.1742657008693;
        Sat, 22 Mar 2025 08:23:28 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f459c4sm36996635ad.82.2025.03.22.08.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Mar 2025 08:23:28 -0700 (PDT)
Date: Sun, 23 Mar 2025 00:23:13 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v5 5/5] btrfs: ioctl: introduce
 btrfs_uring_import_iovec()
Message-ID: <Z97V4cIKINX58r6s@sidongui-MacBookPro.local>
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <20250319061251.21452-6-sidong.yang@furiosa.ai>
 <14f5b4bc-e189-4b18-9fe6-a98c91e96d3d@gmail.com>
 <Z9xAFpS-9CNF3Jiv@sidongui-MacBookPro.local>
 <c9a3c5bb-06ca-48ee-9c04-d4de07eb5860@gmail.com>
 <812ae44c-28e9-40a8-a6f0-b9517c55e513@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <812ae44c-28e9-40a8-a6f0-b9517c55e513@kernel.dk>

On Fri, Mar 21, 2025 at 05:17:15AM -0600, Jens Axboe wrote:
> On 3/21/25 4:28 AM, Pavel Begunkov wrote:
> > On 3/20/25 16:19, Sidong Yang wrote:
> >> On Thu, Mar 20, 2025 at 12:01:42PM +0000, Pavel Begunkov wrote:
> >>> On 3/19/25 06:12, Sidong Yang wrote:
> >>>> This patch introduces btrfs_uring_import_iovec(). In encoded read/write
> >>>> with uring cmd, it uses import_iovec without supporting fixed buffer.
> >>>> btrfs_using_import_iovec() could use fixed buffer if cmd flags has
> >>>> IORING_URING_CMD_FIXED.
> >>>
> >>> Looks fine to me. The only comment, it appears btrfs silently ignored
> >>> IORING_URING_CMD_FIXED before, so theoretically it changes the uapi.
> >>> It should be fine, but maybe we should sneak in and backport a patch
> >>> refusing the flag for older kernels?
> >>
> >> I think it's okay to leave the old version as it is. Making it to refuse
> >> the flag could break user application.
> > 
> > Just as this patch breaks it. The cmd is new and quite specific, likely
> > nobody would notice the change. As it currently stands, the fixed buffer
> > version of the cmd is going to succeed in 99% of cases on older kernels
> > because we're still passing an iovec in, but that's only until someone
> > plays remapping games after a registration and gets bizarre results.
> > 
> > It's up to btrfs folks how they want to handle that, either try to fix
> > it now, or have a chance someone will be surprised in the future. My
> > recommendation would be the former one.
> 
> I'd strongly recommend that the btrfs side check for valid flags and
> error it. It's a new enough addition that this should not be a concern,
> and silently ignoring (currently) unsupported flags rather than erroring
> them is a mistake.
> 
> Sidong, please do send a patch for that so it can go into 6.13 stable
> and 6.14 to avoid any confusion in this area in the future.

Agreed, It could be seen as a bug that the flag is dismissed silently.
I'll write a patch for this.

Thanks,
Sidong

> 
> -- 
> Jens Axboe

