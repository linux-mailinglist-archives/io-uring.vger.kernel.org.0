Return-Path: <io-uring+bounces-7076-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB247A5F7D9
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 15:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4ADF01770A0
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 14:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42A3267B9C;
	Thu, 13 Mar 2025 14:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="PzHs8stW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F98267B85
	for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 14:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741875698; cv=none; b=kD9kclaS63uktFg7/D3Kx+EbEtNuRWab63ush4aTX9VeoH216O1KT/zqfSkSDwNTmVlMCZY26kttztLAVm9rQD+K6ecl7Oi70YM2Y1sJ2q8VY9ZQF9Ga+aK7zNisCZB+jLBhgF+2VxoDo2JsHTn4b1Z1oNjTN+Tk3FWhyjdO9qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741875698; c=relaxed/simple;
	bh=WpvnsUzxl6gpZMtFBMkL0WHekJbk8BwBrLg5RdPfqlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVPpTNzXreifhdLcc4TRR6FFVBKSXHO9RKwpMyM9/2KmoYRKA0/kIctt5wN5EfH/FS/QP7EwTk7TFDh5vFT+5n9kMRUvO29sG+YFl39PZqa1jOVAK4zG3ex41uPIEzkEpiQ8MY9RlGz2Wp2MJC3qsgsRbuGAfimfXqcGe+9diUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=PzHs8stW; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22403cbb47fso20208115ad.0
        for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 07:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741875696; x=1742480496; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L0tetsoKa2ISM18bfiufTSiFquhBJtIAvJUABcLWCV4=;
        b=PzHs8stWv3CkhdJNpveHIyT2gRaaww2ivWO3szaAoNnaXW3VZqM5ipx/kVvRF3dAaH
         /544wV2IdaBd1jtbzHqClaBAuzz0cbTG77luMTeMzuZV8+Pt90x8A1hqlLMWUcHSnhJV
         36gjVMJy9TW2tBrBszvnHx4ax4OiFXTfSjUW3hGsN+Ip6zpgirewI7yen0E6EURXrd1W
         +mUwZwLsI1hL6E0wZNrFRXeUmgVS8zjP4gHJl3kjRftGqVqIgOn0NRabM7ASFDmiakdz
         ZqsAGAZpWubw/WAgMqcTjkpv24CBEX1jI9J6O6w4xhTZUVTfsN1A5uoZ+0JAABaZeGbH
         Godw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741875696; x=1742480496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0tetsoKa2ISM18bfiufTSiFquhBJtIAvJUABcLWCV4=;
        b=RVqVuAWnOZ+Q99ZCMr8+LOp6G52O9e5odiog1dRhn8hqc1zJuZDg0qhWZytWdznR/e
         loC93DLMPYmNsn38VJCDGlA0/io2p28znavmSMeZ7jEBXZWh2EPA8aWYOMm8JJbXYiMy
         WKLPPQzZvGxSwUAjHfp8iCGY62hgc3rqqiHWGDSVtwX8i1/WtQX+1m5U10gs9or5JlQP
         jq159dlQpXTlnJRPtLNra0LsET6mdOVDf+IfFmmWpsN8OFp4wDxQRic+4AQBloI9bVdH
         H+Uxj3NYWv/4RfOpCsrRergl5ZS97F1fT7zrL+PpF7B272ltjngX3S5WnAjsNMOSbYKT
         FQVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHEhIr+qUIVVwynzg9aXQJ9I/9PZjpAxC86WZaqBsIpeRWRutPXhcxmPzx85AXMpi3zGdIr/rw1g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0rNta5kkQTSXfIeyot+1F/AgBoLDNUHyklAH+QE2AEjIn7/DY
	mUlHGSPd/VLsPHDo+xGNBcC6BRp+R5Iheqx+B4NV6xyqYDk1X8whAOy5OYsHiN8=
X-Gm-Gg: ASbGncsq2cTADuxJah1rAWUR5PfxTobDCZ0LQYjEMiqRahTQ8XYVh2m17tSp35RDc4t
	goeeN6eR/tZZmzM+0iIfwSrr6e4LYzcLOj0hT1WCIjc/gVr3pClkGueRAoM+eg/JqROhOdNgew3
	8N5YLSOYI5kFeYy+SIGIx2yQBWeo6SD4lX484aOfseWD70K9ptbXlQAaMLDJYEikk1YQiwM3+vz
	d58a2ugJSXh4LeG0GfXTGt/J9j2GGbpYVe3o+y5CE2mqhSuIWMyFnBYnmQXrvCRHc9lMm6lIXIX
	tMLNnRkaORdkalLIFWaWPI3x6aPiT5OmANa/Kadr7HGE+hEOANOvE1F3/eXswYgHtc1TnW/0oMp
	i+cEGhQ==
X-Google-Smtp-Source: AGHT+IFrm0PyIULGxF7uMa1YAcLldt1ymHl/9crA3Otf7vM1iRhdF/1Q7ffqxaW5uccJLGntcMfu/A==
X-Received: by 2002:a17:903:283:b0:223:fbc7:25f4 with SMTP id d9443c01a7336-2242888bfe4mr406203255ad.14.1741875696042;
        Thu, 13 Mar 2025 07:21:36 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bbe77csm13577465ad.194.2025.03.13.07.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 07:21:35 -0700 (PDT)
Date: Thu, 13 Mar 2025 23:21:31 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/2] introduce io_uring_cmd_import_fixed_vec
Message-ID: <Z9Lp60B4o2Y3AzhD@sidongui-MacBookPro.local>
References: <20250312142326.11660-1-sidong.yang@furiosa.ai>
 <7a4217ce-1251-452c-8570-fb36e811b234@gmail.com>
 <Z9K2-mU3lrlRiV6s@sidongui-MacBookPro.local>
 <95529e8f-ac4d-4530-94fa-488372489100@gmail.com>
 <fd3264c8-02be-4634-bab2-2ad00a40a1b7@gmail.com>
 <Z9Lj8s-pTTEJhMOn@sidongui-MacBookPro.local>
 <ab277f0b-fdf6-4f20-9fe0-0e0a1ebcc906@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab277f0b-fdf6-4f20-9fe0-0e0a1ebcc906@kernel.dk>

On Thu, Mar 13, 2025 at 08:01:15AM -0600, Jens Axboe wrote:
> On 3/13/25 7:56 AM, Sidong Yang wrote:
> > On Thu, Mar 13, 2025 at 01:17:44PM +0000, Pavel Begunkov wrote:
> >> On 3/13/25 13:15, Pavel Begunkov wrote:
> >>> On 3/13/25 10:44, Sidong Yang wrote:
> >>>> On Thu, Mar 13, 2025 at 08:57:45AM +0000, Pavel Begunkov wrote:
> >>>>> On 3/12/25 14:23, Sidong Yang wrote:
> >>>>>> This patche series introduce io_uring_cmd_import_vec. With this function,
> >>>>>> Multiple fixed buffer could be used in uring cmd. It's vectored version
> >>>>>> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> >>>>>> for new api for encoded read in btrfs by using uring cmd.
> >>>>>
> >>>>> Pretty much same thing, we're still left with 2 allocations in the
> >>>>> hot path. What I think we can do here is to add caching on the
> >>>>> io_uring side as we do with rw / net, but that would be invisible
> >>>>> for cmd drivers. And that cache can be reused for normal iovec imports.
> >>>>>
> >>>>> https://github.com/isilence/linux.git regvec-import-cmd
> >>>>> (link for convenience)
> >>>>> https://github.com/isilence/linux/tree/regvec-import-cmd
> >>>>>
> >>>>> Not really target tested, no btrfs, not any other user, just an idea.
> >>>>> There are 4 patches, but the top 3 are of interest.
> >>>>
> >>>> Thanks, I justed checked the commits now. I think cache is good to resolve
> >>>> this without allocation if cache hit. Let me reimpl this idea and test it
> >>>> for btrfs.
> >>>
> >>> Sure, you can just base on top of that branch, hashes might be
> >>> different but it's identical to the base it should be on. Your
> >>> v2 didn't have some more recent merged patches.
> >>
> >> Jens' for-6.15/io_uring-reg-vec specifically, but for-next likely
> >> has it merged.
> > 
> > Yes, there is commits about io_uring-reg-vec in Jens' for-next. I'll
> > make v3 based on the branch.
> 
> Basing patches on that is fine, just never base branches on it. My
> for-next branch is just a merge point for _everything_ that's queued for
> the next release, io_uring and block related. The right branch to base
> on for this case would be for-6.15/io_uring-reg-vec, which is also in my
> for-next branch.

Agreed, for-6.15/io_uring-reg-vec is the right base branch for this. 

Thanks,
Sidong
> 
> This is more of a FYI than anything, as you're not doing a pull request.
> Using for-next for patches is fine.
> 
> -- 
> Jens Axboe

