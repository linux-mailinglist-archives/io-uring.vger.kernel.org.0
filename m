Return-Path: <io-uring+bounces-9692-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4293B505A0
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 20:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C43A560D48
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 18:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 117E430215E;
	Tue,  9 Sep 2025 18:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBmAoIP2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC291301000;
	Tue,  9 Sep 2025 18:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757444097; cv=none; b=HW0uOASmyHHoOL0+V5Hf/LDhJTevafh1TEUUps8/8SxGz8Nv6rHqCWYT+KuIfvjtTEPZsXnORMKWKeNDpVaOy3r7vNrFgvd2A0aHPgZVZClvciQx9A5woNnuVM7lR5wZAq5DO1pBY8JA7HwZ933uUVqe9S/SYfG8eq9GtseIO28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757444097; c=relaxed/simple;
	bh=jY4ZDiOqfedwHS40fQ7APUViCr1cLuPVU29y7/rD8dM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEwDesi0vJi9LX3oFWYPXF2f6RYE+nImEKOLOHhyQBGc21yEl9IP3Se0T2rHQAO/CQrreuU6udoTb6LUxmV9Dfehwao2tZeQcRzJ6M+GoM/DhWnIp8LlnsvUKConJq3iAfE4ZglV8KlJ6T10qG/ZPL3tNlcGLMobPThmu4uke1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBmAoIP2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E86AC4CEF4;
	Tue,  9 Sep 2025 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757444096;
	bh=jY4ZDiOqfedwHS40fQ7APUViCr1cLuPVU29y7/rD8dM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QBmAoIP25QwBASgbLBhCAHpGzGwWCwKhwHDX9iyEh4YOQE2iVo7duqLaHhx8COplO
	 3rczqoEg6pNcdQUWd9fOA4U09/Nyt3ZCnWmAKTjyGWn4cPd8jup+1yh0puvWPj4+IG
	 iNVbloCMZQdPjEQP/9c3309bZD9o2byoKZY3Qbf0NVD66KsIj7njM97s8S4sbEDFQQ
	 F2+7OhXmdLAHd4PxLi9T/CIK2GYXnRBPT6y7HSyrxJ7TALfxZZkPS11MK1b29SACys
	 OOvNKREkZ/B4lK6cPQTfz5KDh/l2sFQdGOjW8Ei6sIR/C3vfVP+q7IEqztWZwxBwqJ
	 6I9uSdcmgqKxA==
Date: Tue, 9 Sep 2025 14:54:53 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	konstantin@linuxfoundation.org, csander@purestorage.com,
	io-uring@vger.kernel.org, torvalds@linux-foundation.org,
	workflows@vger.kernel.org
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <aMB3_VgB4mwp-bzP@laps>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <20250909163214.3241191-1-sashal@kernel.org>
 <20250909172258.GH18349@pendragon.ideasonboard.com>
 <72dd17ad-5467-49d3-9f40-054b1bf875d5@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <72dd17ad-5467-49d3-9f40-054b1bf875d5@kernel.dk>

On Tue, Sep 09, 2025 at 11:26:19AM -0600, Jens Axboe wrote:
>On 9/9/25 11:22 AM, Laurent Pinchart wrote:
>> On Tue, Sep 09, 2025 at 12:32:14PM -0400, Sasha Levin wrote:
>>> Add a new 'b4 dig' subcommand that uses AI agents to discover related
>>> emails for a given message ID. This helps developers find all relevant
>>> context around patches including previous versions, bug reports, reviews,
>>> and related discussions.
>>
>> That really sounds like "if all you have is a hammer, everything looks
>> like a nail". The community has been working for multiple years to
>> improve discovery of relationships between patches and commits, with
>> great tools such are lore, lei and b4, and usage of commit IDs, patch
>> IDs and message IDs to link everything together. Those provide exact
>> results in a deterministic way, and consume a fraction of power of what
>> this patch would do. It would be very sad if this would be the direction
>> we decide to take.
>
>Fully agree, this kind of lazy "oh just waste billions of cycles and
>punt to some AI" bs is just kind of giving up on proper infrastructure
>to support maintainers and developers.

This feels like a false choice: why force a pick between b4-dig-like tooling
and improving our infra? They can work together. As tagging and workflows
improve, those gains will flow into the tools anyway.

It's like saying we should skip -rc releases because they mean we've given up
on bug free code.

Perfect is the enemy of the good. You're arguing against a tool that works now,
just because it's not ideal, and to chase perfection instead. I'd rather be
"lazy" and skip the endless lore hunts.

-- 
Thanks,
Sasha

