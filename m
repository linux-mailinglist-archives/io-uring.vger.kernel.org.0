Return-Path: <io-uring+bounces-5863-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BFAA11189
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 20:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A840166412
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 19:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF195209679;
	Tue, 14 Jan 2025 19:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjVfSd0n"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B243E208994;
	Tue, 14 Jan 2025 19:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736884504; cv=none; b=fnUbLFHN8usnMK0M+DiebkHUQ+KQx8uE3qf1uWCy7Nk6u3SBxR3XqpILx1QUx7AHKhWavse9xQlbjp3oJv39L0oLn/3bZJFtdqkDYP3d9wQrKnk7CxnQke1Jd/A63LTfmOdz+YSiIuTwfekCfZOuHn6uv69SxiCZO1YeDRN1kZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736884504; c=relaxed/simple;
	bh=huRU/7680fWPaVRisg9yYeZG8JokqKmmOuhfyjkWRYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f1rzucdnjkvG6CxECzPMoIE2WVfJBUm7SAFw+pone2+7h7fvHiGUZbs0iS/3/+wgEYS9j4elmmqD6XBHSJxh82osqcCWRFF029qkofM/mcLV/55yMpK1+5Tr8DmkqX/WZEv0JwbetQpuc9dECAzYTfPT3o4T16OEjc4hdKBOtt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjVfSd0n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D603C4CEE3;
	Tue, 14 Jan 2025 19:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736884504;
	bh=huRU/7680fWPaVRisg9yYeZG8JokqKmmOuhfyjkWRYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjVfSd0nh87uS3INYVUBWuySQV9DZ7yD6vtx15eel3Q9ksPUymny3SEeay+7/w/aB
	 rU3vfdCRStv3XdnboLXoSNOdGe/DHY5tAOPGliObkY9h9iDKOP8ZRXs27kqWPnnSWr
	 4gnb9xBSPcO6f9FHBV7rM5oVdETpj5f4QmvA6TTtyXbd4RcigbU1K3ch2ladX6k/UZ
	 K52TH1M/7wMCZfgFZ48UUOC0J4bRxnCBsdB8RBSKrhtRpBcC7iC3z6v7AW+fXpk3R3
	 mlRIoax/iZyhVgqPfGMMljdEmzfC1T5+BMC0N8txvzagBWfiZjC9k0AwAw4JUJFjuE
	 ll4TPzxAaigEQ==
From: SeongJae Park <sj@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Liam.Howlett@oracle.com,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	damon@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/madvise: remove redundant mmap_lock operations from process_madvise()
Date: Tue, 14 Jan 2025 11:54:58 -0800
Message-Id: <20250114195458.53517-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <d1a2d831-dec3-4c63-a712-3adff835f549@lucifer.local>
References: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 14 Jan 2025 18:47:15 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Tue, Jan 14, 2025 at 10:13:40AM -0800, Shakeel Butt wrote:
> > Ccing relevant folks.
> 
> Thanks Shakeel!

Thank you Shakeel, too!

> 
> A side-note, I really wish there was a better way to get cc'd, since I
> fundamentally changed process_madvise() recently and was the main person
> changing this code lately, but on the other hand -
> scripts/get_maintainers.pl gets really really noisy if you try to use this
> kind of stat - so I in no way blame SJ for missing me.

Yes, I always feeling finding not too many, not too less, but only appropriate
recipients for patches is not easy.  Just FYI, I use get_maintainers.pl with
--nogit option[1] and add more recipients based on additional logics[2] that
based on my past experiences and discussions, by default.  And then I run
get_maintainers.pl without --nogit option if I get no response more than I
expected.

I will keep Shakeel-aded recipients for next spins of this patch, anyway.

> 
> Thankfully Shakeel kindly stepped in to make me aware :)
> 
> SJ - I will come back to you later, as it's late here and my brain is fried
> - but I was already thinking of doing something _like_ this, as I noticed
> for the purposes of self-process_madvise() operations (which I unrestricted
> for guard page purposes) - we are hammering locks in a way that we know we
> don't necessarily need to do.
> 
> So this is serendipitous for me! :) But I need to dig into your actual
> implementation to give feedback here.
> 
> Will come back to this in due course :)

No worry, no rush.  Please take your time :)

[1] https://github.com/sjp38/hackermail/blob/master/src/hkml_patch_format.py#L45
[2] https://github.com/sjp38/hackermail/blob/master/src/hkml_patch_format.py#L31


Thanks,
SJ

[...]

