Return-Path: <io-uring+bounces-10673-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 077D7C71B4B
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 02:47:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5193634B258
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 01:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1BAF2236F3;
	Thu, 20 Nov 2025 01:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uF2z7xSs"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F05816EB42;
	Thu, 20 Nov 2025 01:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763603259; cv=none; b=LehxLUdygbahBDgmM6n5WKLwmWaaFf9RQCIqQl/qgs2FG5m4isINVZgc+kLIMe0fLrbzyB7ytxDo9p+6iljFwa9nzhm8E8sTPonJt7PR5SgkmRLxv8aL1eiKt4NuVQYW+Yr6g3fvw6SDUo3r+ctpDePa5hzfAdvYg0zmpUaut44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763603259; c=relaxed/simple;
	bh=Qz0Kt9BVZotF+W8b8C03wV9uEpjzU2IZVkSaOcZVd50=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AvH6jxCmb00Tu1pC9E68hK/IG2HkCQ2rUi3fteRS7RVCxd98MBVlgnbfgacz7Bq+11mxmr99AHS127RFH9nx6yI1texBxvKKBN1LoiUA+0YwLVTYlGXrBHoll7rtuLyDG5WYzWYIYohdSn8tVnM9wZ6SCws3KeZBQ74dXRwQNSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uF2z7xSs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC38C113D0;
	Thu, 20 Nov 2025 01:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763603258;
	bh=Qz0Kt9BVZotF+W8b8C03wV9uEpjzU2IZVkSaOcZVd50=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uF2z7xSsJBEF2o7jOCGEA8BICVnf2Ll7GN/YdEoLbs8PaQeAHioKS/o3SZ7QSxsKt
	 vFnjbh6TICH8PLye1zHlHKdpzDE5Fm345e4L/w0hg/fEJ7Itp2slYgup6C6JZwwIym
	 LLCi+QyeEmLY48F4L7ZzcbTStdyHeEENY8Hfnp0DqQrXSF5r2MrZk7t4OMHkvbN7PR
	 8Qcsuc8hp1q4+vdSlLZQjWoYyrPh5U9WhuFsg9TNqdi8dNwuUtBQRxPyNJujXI9VwL
	 mc5s7M6miwKRs2zV2Elwkq7lUfoGg+X1KHfkkxDDXD+SynQUk6oIGjhckD0gmUEmi4
	 nBJOVjtHwyLhA==
Date: Wed, 19 Nov 2025 17:47:34 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: david.laight.linux@gmail.com
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexei Starovoitov
 <ast@kernel.org>, Andi Shyti <andi.shyti@kernel.org>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Andrew Lunn <andrew@lunn.ch>, Andrew Morton
 <akpm@linux-foundation.org>, Andrii Nakryiko <andrii@kernel.org>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel
 <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Bjorn
 Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, Christian
 Brauner <brauner@kernel.org>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Christoph Hellwig <hch@lst.de>, Daniel Borkmann
 <daniel@iogearbox.net>, Dan Williams <dan.j.williams@intel.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Dave Jiang <dave.jiang@intel.com>,
 David Ahern <dsahern@kernel.org>, David Hildenbrand <david@redhat.com>,
 Davidlohr Bueso <dave@stgolabs.net>, "David S. Miller"
 <davem@davemloft.net>, Dennis Zhou <dennis@kernel.org>, Eric Dumazet
 <edumazet@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>,
 Jakub Sitnicki <jakub@cloudflare.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Jarkko Sakkinen
 <jarkko@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jens Axboe
 <axboe@kernel.dk>, Jiri Slaby <jirislaby@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, John Allen <john.allen@amd.com>, Jonathan Cameron
 <jonathan.cameron@huawei.com>, Juergen Gross <jgross@suse.com>, Kees Cook
 <kees@kernel.org>, KP Singh <kpsingh@kernel.org>, Linus Walleij
 <linus.walleij@linaro.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Mika Westerberg <westeri@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Namhyung Kim
 <namhyung@kernel.org>, Neal Cardwell <ncardwell@google.com>,
 nic_swsd@realtek.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Olivia
 Mackall <olivia@selenic.com>, Paolo Abeni <pabeni@redhat.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Peter Huewe <peterhuewe@gmx.de>, Peter
 Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Srinivas Kandagatla
 <srini@kernel.org>, Stefano Stabellini <sstabellini@kernel.org>, Steven
 Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, "Theodore Ts'o"
 <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>, Tom Lendacky
 <thomas.lendacky@amd.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, x86@kernel.org, Yury Norov
 <yury.norov@gmail.com>, amd-gfx@lists.freedesktop.org, bpf@vger.kernel.org,
 cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org,
 io-uring@vger.kernel.org, kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-usb@vger.kernel.org, mptcp@lists.linux.dev, netdev@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 00/44] Change a lot of min_t() that might mask high bits
Message-ID: <20251119174734.5cba3f95@kernel.org>
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Nov 2025 22:40:56 +0000 david.laight.linux@gmail.com wrote:
> I've had to trim the 124 maintainers/lists that get_maintainer.pl finds
> from 124 to under 100 to be able to send the cover letter.
> The individual patches only go to the addresses found for the associated files.
> That reduces the number of emails to a less unsane number.

Please split the networking (9?) patches out to a separate series.
It will help you with the CC list, and help us to get this applied..

