Return-Path: <io-uring+bounces-11585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B44D127B1
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 13:12:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A62A30341F5
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 12:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB033570AE;
	Mon, 12 Jan 2026 12:11:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F42D2D2382
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 12:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768219871; cv=none; b=U0qTbW8bc9xqhSLKlhXQcmLpV/xEm8Ge4jQwJR3nCP62GQImHxdZM9bYwpzZHYDUqkegao3rlBkFwvsPzd411RmL2nFe+SaUsXHi/3fu1Xi0Oc1nOu4S7mfav8WHUK1g35hE9/gkZC/Sa1jSPwaE8auUOYfuR4HIgPj/R7///NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768219871; c=relaxed/simple;
	bh=SMqxyhhRYtV1TWxgft1yeucWp7stiqhswOISklg6uiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8fzq7oLZR0Aroe/US2kEBd1ACz7sFisoGjSc/j4NPnETPYmWKvc9nXSwNA+XbB5OLUeui/ilachaLQQ3PZNlqS8lG/OsN+zOCbrNn+dZ74Tm7swa7d5xKNoE29Mxje8Iciv/OFg4VdA/kkzHoyAdNR+GEUcpT0ZdPch+Lrl36A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-4558f9682efso4029629b6e.3
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 04:11:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768219869; x=1768824669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMqxyhhRYtV1TWxgft1yeucWp7stiqhswOISklg6uiI=;
        b=ZwmTf3hp34K1C6pwAfXl/go6ynBpCYrd/hZjbrintUQZFvufw3L+OyDgFeNeJp6sqQ
         olzItXP0ZZx3oqcS+D1VKWLNQRdOL+YGVU4z18oBJeu1/PjYo1Fi7MDnme4+gDt40uQd
         h1OZctU+dzvlDcqCrjzgucoUK/gxmVynurx1oDwKEyrDmC5FbpHi3k1zhmQMjgJ/kxNT
         majLMe3O8AGhn5EndMdZ+CpJB9/sc66jIotEXj3L62FhvnrsqaReoUi7JD+2AD1A+zOr
         EuvH+bsPaqI5B8rtenyYNTX+PAK97dWp+KpgHHPywOgjllq5kAvqVxYCxxGhYkGERihp
         g4Og==
X-Forwarded-Encrypted: i=1; AJvYcCW3lLDuhO+KuxnGR5x90G6LdBJSMfpVbGUIb1t6ljKuViXa4DylW+2Xq5OI6oU8CEPPr59BnYmSxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjQigaGBtreuK59A43EKuPT4QYDZDF6LzojDNWQimQY2eFWnwn
	AJoaJ3UrQB5N5UybvGuVibM0PPtYOy8GhkAu2QvdvvdPhR3xhLwcIxWu
X-Gm-Gg: AY/fxX6QVHvMVswgeWcOpIjE1aPmB6w7N4NTWAuVfJJ4vfIh1rFcVRzAPba/m8nDrJ5
	3oeeW0tgI+FJefgsDGnucmy0bdkvtMSooj6/iP2q6gGmhJeaB7XogFc9JupbvYb8qc+YHBQqaLE
	98lnDnAj4b7uhoaxkPwYtXbttRhpsNCQFWk5X1Wyia6FyGAeLQ+zp6xFoxv7cop9Y9XRPflhgXa
	9Jm8VHVBtO75oNVJgUL9iRSoYtHOdisIZfN1ZTvsodF15fvKPXd48bQYKhf5Qhn2BrK5T3Qz0b7
	q5ERJQxWtOVaVWqLqo23vWroFERpuDPpicygaukAFJMcS2APKUzIe6fNY/wHBataarzwl2j2h6X
	lNCBL7UMdTFiOmouIb7FOkXrrzEKt9Oi9/ekGzbcvwOIU3yzA2C5nb2YuGHgHpAwD0NtoMPbgnq
	wHyQ==
X-Google-Smtp-Source: AGHT+IGXIOQe/EY+jwqZoDM7xIvw4NaZjtfc5THflzkY6HihSYlJ6m+8kEslujhnbhMTId2oOMjfaA==
X-Received: by 2002:a05:6808:179c:b0:450:db06:6079 with SMTP id 5614622812f47-45a6bea9be5mr8383186b6e.53.1768219869327;
        Mon, 12 Jan 2026 04:11:09 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:5f::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e183ac3sm7902058b6e.4.2026.01.12.04.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 04:11:08 -0800 (PST)
Date: Mon, 12 Jan 2026 04:11:06 -0800
From: Breno Leitao <leitao@debian.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: Trim out unused includes
Message-ID: <wuha2oln3kdumecdsmpttykdq2p5bwp6db3cfoyqoy5ftnedmg@ftlotbrnrev7>
References: <20260105230932.3805619-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105230932.3805619-1-krisman@suse.de>

Hello Gabriel,

On Mon, Jan 05, 2026 at 06:09:32PM -0500, Gabriel Krisman Bertazi wrote:
> Clean up some left overs of refactoring io_uring into multiple files.
> Compile tested with a few configurations.

Do you have a tool to detect those unused header? I am curious how is
the process to discover unused headers in .c files.

Thanks
--breno

