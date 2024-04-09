Return-Path: <io-uring+bounces-1474-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4146089E0E6
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 19:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F18AA28365D
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 17:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E60155389;
	Tue,  9 Apr 2024 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aotgi/mj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285BB152DEB;
	Tue,  9 Apr 2024 16:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712681995; cv=none; b=g7ibty6h1z9GuDiYBSd+0+zOxHuXR4ymiaoYcr56bPpzvRLE0EwxXI/LBp95BXa1NCyGFZzbxm1Zigqw9y2Me2BdfHAd4rIJUI4xvz/aLbbYPxkRhCZ453Lny0vJfFuYsvw74LomoU/U5QrXtf4MQzerLxN17g7e4eslPfjNbr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712681995; c=relaxed/simple;
	bh=FncKWsKbg/hFr6GnUHocdduFJVjZhPin/nlM8ZG9evk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wv3Ey/7TO3BWslQ+173irg2YxGx4VBimPA3IC65TMytW9YT5SB2NOxPpvdtaET7Gcz/Qjyj44dHN67fSZoOoH15FE2L1BMGSB+8lVvnkvKBOWr93ZQvmEHu9lS23VNx6BAak6vYW+tMvg5Agn6yeOOulpxraH4choKBzFdUqwk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aotgi/mj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DAEC43394;
	Tue,  9 Apr 2024 16:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712681994;
	bh=FncKWsKbg/hFr6GnUHocdduFJVjZhPin/nlM8ZG9evk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aotgi/mjzEYHwzEVw6SPTEWRw8pgK6bl3EZbUUhiLE2wDXCzJVqGLZVPoNr/CMvgT
	 H9TmtLLcE1bCzZaEkYCwTzITgO05jeex9m4DsVZXuD3Y8sQ+/2basDNQ+0TD4lKlCT
	 cGAHdmD3jRpxUvKfiA6b3PdEL9gJRuNamxiGi1rNQHRm69ypMekvMNLj3gIh5DWQ+K
	 3MQxlZl4KxdIiWu2pYBK5d2n2bQ+L9wlms3e/u5qct/dU3fuk6T1O1cYJYm9lqyMn8
	 nlMcs3HEWsfIHLaxSP+bY9pq5qXzsIR5fa9hpFrFifzsLQ8DpGnVHFk0OV/Ayuor1W
	 q2lPrqPTwWVxw==
From: Will Deacon <will@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Atish Patra <atishp@atishpatra.org>,
	Anup Patel <anup@brainfault.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Joel Granados <j.granados@samsung.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] sysctl: Remove sentinel elements from misc directories
Date: Tue,  9 Apr 2024 17:59:35 +0100
Message-Id: <171267686554.3168517.3836229489434629100.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
References: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 28 Mar 2024 16:57:47 +0100, Joel Granados wrote:
> What?
> These commits remove the sentinel element (last empty element) from the
> sysctl arrays of all the files under the "mm/", "security/", "ipc/",
> "init/", "io_uring/", "drivers/perf/" and "crypto/" directories that
> register a sysctl array. The inclusion of [4] to mainline allows the
> removal of sentinel elements without behavioral change. This is safe
> because the sysctl registration code (register_sysctl() and friends) use
> the array size in addition to checking for a sentinel [1].
> 
> [...]

Applied drivers/perf change to will (for-next/perf), thanks!

[7/7] drivers: perf: Remove the now superfluous sentinel elements from ctl_table array
      https://git.kernel.org/will/c/f66ae597411c

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

