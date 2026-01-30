Return-Path: <io-uring+bounces-11997-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKmWAVjffGmpPAIAu9opvQ
	(envelope-from <io-uring+bounces-11997-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 17:42:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 464D9BC964
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 17:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E8938300A3B5
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 16:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3169C34D934;
	Fri, 30 Jan 2026 16:41:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1BF3191A7
	for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 16:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769791315; cv=none; b=b2WQrff/PjHY9YIvK+akg7R5ZHV8Vpo7i93wAxMIqZ00sHH59GXtfTCP1NDu0CKyyFKXyEpNujSrMi4ZoP1jBbBEHiqrvnzFWJ5MY/JeDx5AruMEr+QxRE/e/ZhUk3abJh3wsvbewZTJNH4SbBTT69pUTMqh32rpx9yZZHQdpEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769791315; c=relaxed/simple;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=eyNhQWyd262sjhpp2OT2LOhQ81mcPNvYL6Jv5GQr+S3zWu92CbJKxQY8j+cyVnAagDvCJxHvVFAMgXzIZd7NFXea+dCRBsVmf0CuPVYeZlAGsMesI7jt+2tT3I/36OSbnXeggXT/cH8/ilOGqqM42lRKh2eNKCeGXVkXO3zV3yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-409682c165fso7551987fac.3
        for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 08:41:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769791313; x=1770396113;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=WdV3t/k+5kDac81GvcpS3/1E/v3Nj592gEr5D3nNW2KHCe1M3gNv8VxlZcP17/PLet
         S7G5O/zmQ2zkV4A6LZLQllzOhbfVTCvHXagf1hUYpk7fjti95AZjenomdPLr1VcuBVs6
         DWDOTVyPTqd4hEGh8RYBAX3km9+HS6SGV0HCq4USEefiwQa+gSiWHaU+IY1bKD0US/Ru
         ECgknrkSVy/UeRc31lpkCLLnIAyC3USHyfijdAQhk00wNTX7+3xnQlE1nk5s4LWVm2m8
         cWniagnNjddUquWQW6V+H8nnKWPPGkrTUsPKif+XbdRRybT8gi0Unv68hv5ULhLCzDDH
         VlSw==
X-Forwarded-Encrypted: i=1; AJvYcCWk71JZ2GJj48tOnc+HBt9LjekZDd4W+yZGNQXIeAN6O81AVDcTXcFX3No/Q5RIwL5BVy6XqUFlXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUc4yn0pAdpklJt2T3SjAVsflcfa6Y5imhbFlZKbBV4W9GNE+I
	vl/jOwkRO0g45aUvyx8GpR/7NoCaDY/+z0o/M8Qd8O/u+O/CDC/KKIY6jTTxM6vPat8vzFquJUd
	UKyayo1OvBWsTj/ppgTXLEYZFmeHe2g4DkYGBzSct565s+9pGpHNUmYsg1jw=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4613:b0:663:cb2:d67d with SMTP id
 006d021491bc7-6630f04c2bamr1438160eaf.37.1769791312692; Fri, 30 Jan 2026
 08:41:52 -0800 (PST)
Date: Fri, 30 Jan 2026 08:41:52 -0800
In-Reply-To: <2A678D66-2516-4130-A34B-6A0B3549EEA7@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697cdf50.050a0220.371857.00e6.GAE@google.com>
Subject: Re: Re: [syzbot ci] Separate compound page from folio
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org, apopple@nvidia.com, axboe@kernel.dk, 
	balbirs@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, hannes@cmpxchg.org, 
	io-uring@vger.kernel.org, jackmanb@google.com, jgg@nvidia.com, 
	lance.yang@linux.dev, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, npache@redhat.com, osalvador@suse.de, rppt@kernel.org, 
	ryan.roberts@arm.com, surenb@google.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, willy@infradead.org, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11997-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	SINGLE_SHORT_PART(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[30];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 464D9BC964
X-Rspamd-Action: no action


Unknown command


