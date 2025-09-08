Return-Path: <io-uring+bounces-9638-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95219B487FC
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 11:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C85A3C1A3A
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 09:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20DF2EC543;
	Mon,  8 Sep 2025 09:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g/d2qHvh"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C818188713;
	Mon,  8 Sep 2025 09:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757322668; cv=none; b=IIZkbFH/GJhqbWJwvrUVUQADfcz0YbjVma42LI3A6t6mWAuFr48TCiUkbjINKpIT6/j2mb+NfGrvv4xOlonX6yib6SXA+DW5mjWexnqmLH+xLzbGNExG/umaE/Bpcv3WVnG6X3BSxf8hf50/CBACLaxVXDfL7OcsrnOieHolDxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757322668; c=relaxed/simple;
	bh=cswmx7ptxpYIBCZQu6oWFXqzBcIcfFh6RwYlTTHdkRg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HuqryV9XxXVO0FEG+3k/i/2z+3fbTXphIsOE0WxjCce91E1dCRcArBOeNckL1lYutJkw80+3TWz6wA2mAS6BK5pxDXctQG6QNjsC7KnxjPsZx0jx2QdRetOD8vIgBMBBqB2qeX2hC3O1PikfBugA33L/z2nm69tuFou7Q380CTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g/d2qHvh; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757322668; x=1788858668;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=cswmx7ptxpYIBCZQu6oWFXqzBcIcfFh6RwYlTTHdkRg=;
  b=g/d2qHvhEKJfI9vmJHdpbfvMUQcCGlYn2KhFZwch9DgbuW/Mz1rinawy
   n1M7uzbAC90DiaiZtqIJdqIkeO4b7MYfjtkskyEZF/BjcABnryhoGi5NY
   XPD3M5+8iEBC3UyQyUlobw2ITIFVplQTrx3EfuQUwXo471w8tR1E9iulr
   xyRE7L5eAXBpq6ydt3clQUKeOavvtR0ZsIWz/86yqJDlRAZAhA087z8S/
   c4Yz3Fac9hZ/DGCZEMFI7FmEUodVEan7EXjyaGvFIA9bhJ8uHRL6eLv79
   dVXgnxrVRyK7LTJbvNXDqwpSwex+xj4sc+fsojnA5Ir24Cxd8sPt2NKNu
   A==;
X-CSE-ConnectionGUID: z0N8NgpQR+udhR41pyENTw==
X-CSE-MsgGUID: 8X9DsWOaTM+pO7QBOXltxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11546"; a="69828564"
X-IronPort-AV: E=Sophos;i="6.18,248,1751266800"; 
   d="scan'208";a="69828564"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 02:11:08 -0700
X-CSE-ConnectionGUID: QZO9IXB9RWa+Fpw1hzTQdA==
X-CSE-MsgGUID: Pnp32DZySveLb1Wf6lspcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,248,1751266800"; 
   d="scan'208";a="177946272"
Received: from carterle-desk.ger.corp.intel.com (HELO localhost) ([10.245.246.204])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 02:11:04 -0700
From: Jani Nikula <jani.nikula@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, Konstantin Ryabitsev
 <konstantin@linuxfoundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>, io-uring
 <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
In-Reply-To: <CAHk-=wjVOhd6xt0TiSakQx9jKBBveQr8GZiqF6Y6M9Ti1suw-w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
 <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <2025090614-busily-upright-444d@gregkh>
 <20250906-almond-tench-of-aurora-3431ee@lemur>
 <CAHk-=wh8hvhtgg+DhyXeJSyZ=SrUYE85kAFRYiKBRp6u2YwvgA@mail.gmail.com>
 <20250906-macho-reindeer-of-certainty-ff2cbb@lemur>
 <CAHk-=wjVOhd6xt0TiSakQx9jKBBveQr8GZiqF6Y6M9Ti1suw-w@mail.gmail.com>
Date: Mon, 08 Sep 2025 12:11:01 +0300
Message-ID: <882495028cfb73b2db0119a8c37e34a85344ce2e@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, 06 Sep 2025, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sat, 6 Sept 2025 at 11:50, Konstantin Ryabitsev
> <konstantin@linuxfoundation.org> wrote:
>>
>> The primary consumer of this are the CI systems, though, like those that plug
>> into patchwork
>
> Yes, for a CI, it makes sense to try to have a fixed base, if such a
> base exists.
>
> But for that case, when a base exists and is published, why aren't
> those people and tools *actually* using git then? That gets rid of all
> the strangeness - and inefficiency - of trying to recreate it from
> emails.
>
> So I'd rather encourage people to have git branches that they expose,
> if CI is the main use case.

For i915 and xe, we'll want *all* patches go through CI. I'm sure there
are other drivers like that. CI is not the "main" use case, just one use
case. I'd like to have patches on the list for review and discussion,
and git branches for CI and everything else.

Insert "Both? Both. Both. Both Is Good." meme here.

To me it sounds like it would be useful to have tooling (b4? git
send-email?) that could push a git branch *and* send those changes as a
patch series, with a well-formed, machine-readable part in the cover
letter that points at the git repo.

I guess you could have server git hooks or forge workflows to send the
patches as well.

(Though you still can't review what's on the list, and blindly apply
what's in the git repo.)


BR,
Jani.


-- 
Jani Nikula, Intel

