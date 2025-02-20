Return-Path: <io-uring+bounces-6572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF185A3CEA5
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 02:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD6213AF61D
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 01:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CD1192B82;
	Thu, 20 Feb 2025 01:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NcBffzgl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB7F41C7F;
	Thu, 20 Feb 2025 01:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740014728; cv=none; b=TyqsufpUkdBD3F2VlVegWXCQAjdIg+c4KLIhpEAuiO3UHbfNUyy1pkV4qsiswRKtsCS7rEJ3m8C7mc/867f3IJvHiEOkn45w0uO2nKrjsNOuBrSpZWtEpchlSvtGybeRUE62jE9NzXIAHtEDDXNvjETmVgBbDhZBSSXr44CTy9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740014728; c=relaxed/simple;
	bh=KQTq2a+2+8ItYrEFCXOwG/axuRFPnA1J6uuf0x1SSzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHGeOL45AiJOv5wCXcXAxjxIUhEQ736e7avdTMpK9XY3xGtqDuA/uLSc+tZ/hOixldZMGVRGnu1m13NMVplkWHLezgtEudYGunor42W7cmqZmfAYPfoPJmg/qwanj4hR75GVGbEnlMrn3iRktcZkkv4n1f9PRJ33cP2GUVltJ4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NcBffzgl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97111C4CED1;
	Thu, 20 Feb 2025 01:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740014728;
	bh=KQTq2a+2+8ItYrEFCXOwG/axuRFPnA1J6uuf0x1SSzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NcBffzglxoIUj4+wj3+Q/FOX9RgGjv88h/v8apMHc+TnsqUt/2HZNuUn4oDsmu983
	 ZYqPhffV/YoHFWq6XlPyRjwIR5nStSbx51tgr/+yFZKBxGxUOod/dHdhgILoF7Hzbs
	 jZePkN3HyzohXUs9BXIWVX65xsUuz4MuRQz3qq90GXZxxRoOiG3KorVyJBzUTTH9qQ
	 5VGQUWZAMr3/IDkODi/+Gtln9qYJUUVQkEoY4zB9oIFuzOPzfvs8a5ZmcEQbGA+PQO
	 EOJHMLUQLg2RNP7ZShh4tbVXOszxlR/vDbyILcKR0gLR/j2EwezbEJ7ZTEEXbycAuR
	 C1s+6uwoH4eeA==
Date: Wed, 19 Feb 2025 18:25:25 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv4 1/5] io_uring: move fixed buffer import to issue path
Message-ID: <Z7aEhR8qh3P58hkE@kbusch-mbp>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-2-kbusch@meta.com>
 <c4a0cdb8-ac99-4a7a-9791-d2c833e45533@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4a0cdb8-ac99-4a7a-9791-d2c833e45533@gmail.com>

On Wed, Feb 19, 2025 at 04:48:30PM +0000, Pavel Begunkov wrote:
> We're better to remove the lookup vs import split like below.
> Here is a branch, let's do it on top.
> 
> https://github.com/isilence/linux.git regbuf-import

Your first patch adds a 10th parameter to an nvme function, most of
which are unused in half the branches. I think we've done something
wrong here, so I want to take a shot at cleaning that up. Otherwise I
think what you're proposing is an improvement.

