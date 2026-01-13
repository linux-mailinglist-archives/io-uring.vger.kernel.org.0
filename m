Return-Path: <io-uring+bounces-11618-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C39D1B013
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 20:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DCE7F30A0F68
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 19:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5423C364050;
	Tue, 13 Jan 2026 19:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="wVhY9iZL"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB933624AC;
	Tue, 13 Jan 2026 19:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768331740; cv=none; b=eJ58SGRr11jzNSW/K6vbD82jbJfW+GIhafiBmeDuIMRnL8TzyMPqKtnSmrsNRDHXLFmeZhAYhCEGBI3FqW80v4OPNKzdgsf1bli5Ag9ic3xg5JuGAYm/j0TUdB+uFGUD3Jl+ASDwrtFV9mokrWrcoTiyxwEI552q+FWLv93m9XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768331740; c=relaxed/simple;
	bh=I6UITsJP9IZGg0x9KUYtzcKMszxjLObOfiJ3tDF6NAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZncNi8YJEt5pXQ169o2eeIXvMWvIzmblt/YWc6qVHEn3TQYzA4VtNTeqjgW2JVzbweWru7PjXr1MMFnEOj4d3ZCEauwqMMhqmyDa191v8+E4nyX/reTYFV3kk3gvhOxEKVzIVZZWgKV6sPmhuGNquEHIoGEFUh7eA1xMywBLKmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=wVhY9iZL; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XgGrVDhdd2cjZ6Fq5+hoLI+F3LjOb87+IxBIMIOVNqM=; b=wVhY9iZLZqukol8KYcnVYSugOA
	MmnaSOcyoX/M+xamn/giGAbPACFWWXrO/LR3ee+FiElnq9yOUZ/Ih0q5hPJoFEyJzoQur/V2bvSUh
	VkjGMUdNU9WfdOJ6kbA3O7W+XtQg3isncUHGyOkjMBlf12Gkp0nG8W12phisXX0Zzp14R25Tp8cpd
	wJp04JhZC8Qh9iJAh9aj8VR8Fz3WG+f/hW18UfvauSjwV2Gjt1i4Z69MPOQ07Zw4u058s0FoqW5Kt
	jgVPjZQTJkDK7HEBoCtAgVFPT2wIeCVWT7cowHOM843E52KWJqntYihKnyvzuo30wed9l0Zg8pmHy
	zMMhgG7A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfjt0-0000000FUet-3QCS;
	Tue, 13 Jan 2026 19:17:03 +0000
Date: Tue, 13 Jan 2026 19:17:02 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com,
	paul@paul-moore.com, axboe@kernel.dk, audit@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/59] struct filename: saner handling of long names
Message-ID: <20260113191702.GP3634291@ZenIV>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
 <20260108073803.425343-16-viro@zeniv.linux.org.uk>
 <dc5b3808-6006-4eb1-baec-0b11c361db37@sirena.org.uk>
 <20260113153953.GN3634291@ZenIV>
 <20260113190701.GO3634291@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113190701.GO3634291@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Jan 13, 2026 at 07:07:01PM +0000, Al Viro wrote:

> FWIW, an unpleasant surprise is that LTP apparently doesn't test that
> case anywhere - the effect of that braino is to lower the cutoff for
> name length by 48 characters and there's not a single test in there
> that would test that ;-/
> 
> chdir04 does check that name component is not too long, but that's
> a different codepath - it's individual filesystem's ->lookup() rejecting
> a component.
> 
> Oh, well - not hard to add (to the same chdir04, for example)...

Crude variant on top of https://github.com/linux-test-project/ltp #master:

diff --git a/testcases/kernel/syscalls/chdir/chdir04.c b/testcases/kernel/syscalls/chdir/chdir04.c
index 6e53b7fef..7e959e090 100644
--- a/testcases/kernel/syscalls/chdir/chdir04.c
+++ b/testcases/kernel/syscalls/chdir/chdir04.c
@@ -11,6 +11,8 @@
 #include "tst_test.h"
 
 static char long_dir[] = "abcdefghijklmnopqrstmnopqrstuvwxyzabcdefghijklmnopqrstmnopqrstuvwxyzabcdefghijklmnopqrstmnopqrstuvwxyzabcdefghijklmnopqrstmnopqrstuvwxyzabcdefghijklmnopqrstmnopqrstuvwxyzabcdefghijklmnopqrstmnopqrstuvwxyzabcdefghijklmnopqrstmnopqrstuvwxyzabcdefghijklmnopqrstmnopqrstuvwxyz";
+static char long_path_4096[4096+1];
+static char long_path_4094[4094+1];
 static char noexist_dir[] = "noexistdir";
 
 static struct tcase {
@@ -20,16 +22,26 @@ static struct tcase {
 	{long_dir, ENAMETOOLONG},
 	{noexist_dir, ENOENT},
 	{0, EFAULT}, // bad_addr
+	{long_path_4096, ENAMETOOLONG},
+	{long_path_4094, 0},
 };
 
 static void verify_chdir(unsigned int i)
 {
-	TST_EXP_FAIL(chdir(tcases[i].dir), tcases[i].exp_errno, "chdir()");
+	if (tcases[i].exp_errno)
+		TST_EXP_FAIL(chdir(tcases[i].dir), tcases[i].exp_errno, "chdir()");
+	else
+		TST_EXP_PASS(chdir(tcases[i].dir), "chdir()");
 }
 
 static void setup(void)
 {
 	tcases[2].dir = tst_get_bad_addr(NULL);
+	for (int i = 0; i < 4096; ) {
+		long_path_4096[i++] = '.';
+		long_path_4096[i++] = '/';
+	}
+	memcpy(long_path_4094, long_path_4096, 4094);
 }
 
 static struct tst_test test = {

