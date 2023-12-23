Return-Path: <io-uring+bounces-354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9E181D1E8
	for <lists+io-uring@lfdr.de>; Sat, 23 Dec 2023 04:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 913501F232EE
	for <lists+io-uring@lfdr.de>; Sat, 23 Dec 2023 03:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E05381111;
	Sat, 23 Dec 2023 03:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Eflw0YT3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDC8EC7
	for <io-uring@vger.kernel.org>; Sat, 23 Dec 2023 03:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-357d0d15b29so174125ab.1
        for <io-uring@vger.kernel.org>; Fri, 22 Dec 2023 19:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703302256; x=1703907056; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mKUKzM+6ifcXsunzZjiqCC3leVlDqBJ+JFGnvTMz+AA=;
        b=Eflw0YT3ZUjkY6ZvadWeynhcdxaJD29Q/tFPMHKKxv6LtljiLp44xAA98nmnIW2YjN
         qz2oRQbU43ucqWkZUOuS1TJYL88/Jc2WZRctuelpD5Lo74plx9RaR6yWHUmVjoC/9FZL
         eQFgtFK+w/mR1jhSsuHuBQNqkvgnri/Fqz2S7j3Cz76S1SeCQ0UhaNiIDxa5iFSS1LPq
         iL6+CickT+vSzO4NGbdwEsYdnST+YF2YvssepGZFfGLXdfNdTI0veIERekedlWtFGKdE
         Y+R6kr9sfMb4ohap+NBqmHssKty+6876Uzx0vx+G//lXY/M9r5bHciJHL+SlDGvm4aVx
         g13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703302256; x=1703907056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mKUKzM+6ifcXsunzZjiqCC3leVlDqBJ+JFGnvTMz+AA=;
        b=KU7z+0sI/55s2yGgXqyTGyZXgjZZRQcM3tfsdrlIjxaNfVB9kjE4xADnjs8WAjtBa/
         fUdNTRbmFsmS24PuI/xErVXmOYBf3Ynh74kOUAwNXD5tVgDooXNrepRKHTScHOVMHl34
         jUehKkDMusnEYakUwj2chGzHD+RUAWuTOH/cZzm/Muq4JPtxcJJaieu3YREoaCDRCYlD
         If/B8k2bCKgtZy4dqal/zHna0JYqgFBlqZ0caOGkTRg4A+oRegXlvzvXHRWeDYqJtSko
         5ov+nXoCl7cRxlAHyctIv+9K+Gw1qVX4lIoJadGfZzMdXsypIFC4LL+TfRhtOtZySFpK
         f7Tg==
X-Gm-Message-State: AOJu0Yzo9WM2WGf5z/Uu8jeez7EH56Uz7LZ7upwtRLSje3HvqdsZKPE5
	18ZG2eeeEUSFVLtFrPvOtDrz2InhAP/Q
X-Google-Smtp-Source: AGHT+IGqf8TH2N7OR0ICuaHZpx7wnuWDnl0ZbZwaxvo0ZYgzK8CgNYCVQOn1vsdkFaJssQZO57bSwA==
X-Received: by 2002:a92:d28c:0:b0:359:c80d:f75 with SMTP id p12-20020a92d28c000000b00359c80d0f75mr218341ilp.10.1703302256295;
        Fri, 22 Dec 2023 19:30:56 -0800 (PST)
Received: from google.com ([100.64.188.49])
        by smtp.gmail.com with ESMTPSA id y21-20020a5e8715000000b007baa4dbcfb4sm482689ioj.0.2023.12.22.19.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 19:30:55 -0800 (PST)
Date: Fri, 22 Dec 2023 20:30:50 -0700
From: Yu Zhao <yuzhao@google.com>
To: syzbot <syzbot+03fd9b3f71641f0ebf2d@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm] WARNING in get_pte_pfn
Message-ID: <ZYZUarJep8b746Et@google.com>
References: <000000000000f9ff00060d14c256@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f9ff00060d14c256@google.com>

On Fri, Dec 22, 2023 at 12:11:21AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0e389834672c Merge tag 'for-6.7-rc5-tag' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1454824ee80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f21aff374937e60e
> dashboard link: https://syzkaller.appspot.com/bug?extid=03fd9b3f71641f0ebf2d
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b4ef49e80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=118314d6e80000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/e58cd74e152a/disk-0e389834.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/45d17ccb34bc/vmlinux-0e389834.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b9b7105d4e08/bzImage-0e389834.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+03fd9b3f71641f0ebf2d@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5066 at mm/vmscan.c:3242 get_pte_pfn+0x1b5/0x3f0 mm/vmscan.c:3242
> Modules linked in:
> CPU: 1 PID: 5066 Comm: syz-executor668 Not tainted 6.7.0-rc5-syzkaller-00270-g0e389834672c #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023
> RIP: 0010:get_pte_pfn+0x1b5/0x3f0 mm/vmscan.c:3242
> Code: f3 74 2a e8 6d 78 cb ff 31 ff 48 b8 00 00 00 00 00 00 00 02 48 21 c5 48 89 ee e8 e6 73 cb ff 48 85 ed 74 4e e8 4c 78 cb ff 90 <0f> 0b 90 48 c7 c3 ff ff ff ff e8 3c 78 cb ff 48 b8 00 00 00 00 00
> RSP: 0018:ffffc900041e6878 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 000000000007891d RCX: ffffffff81bbf6e3
> RDX: ffff88807d813b80 RSI: ffffffff81bbf684 RDI: 0000000000000005
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000200 R11: 0000000000000003 R12: 0000000000000200
> R13: 1ffff9200083cd0f R14: 0000000000010b21 R15: 0000000020ffc000
> FS:  0000555555f4d480(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000005fbfa000 CR4: 0000000000350ef0
> Call Trace:
>  <TASK>
>  lru_gen_look_around+0x70d/0x11a0 mm/vmscan.c:4001
>  folio_referenced_one+0x5a2/0xf70 mm/rmap.c:843
>  rmap_walk_anon+0x225/0x570 mm/rmap.c:2485
>  rmap_walk mm/rmap.c:2562 [inline]
>  rmap_walk mm/rmap.c:2557 [inline]
>  folio_referenced+0x28a/0x4b0 mm/rmap.c:960
>  folio_check_references mm/vmscan.c:829 [inline]
>  shrink_folio_list+0x1ace/0x3f00 mm/vmscan.c:1160
>  evict_folios+0x6e7/0x1b90 mm/vmscan.c:4499
>  try_to_shrink_lruvec+0x638/0xa10 mm/vmscan.c:4704
>  lru_gen_shrink_lruvec mm/vmscan.c:4849 [inline]
>  shrink_lruvec+0x314/0x2990 mm/vmscan.c:5622
>  shrink_node_memcgs mm/vmscan.c:5842 [inline]
>  shrink_node+0x811/0x3710 mm/vmscan.c:5877
>  shrink_zones mm/vmscan.c:6116 [inline]
>  do_try_to_free_pages+0x36c/0x1940 mm/vmscan.c:6178

#syz test

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9dd8977de5a2..041f9ad8f95b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3230,7 +3230,8 @@ static bool get_next_vma(unsigned long mask, unsigned long size, struct mm_walk
 	return false;
 }
 
-static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr)
+static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr,
+				 struct page *page)
 {
 	unsigned long pfn = pte_pfn(pte);
 
@@ -3239,8 +3240,14 @@ static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned
 	if (!pte_present(pte) || is_zero_pfn(pfn))
 		return -1;
 
-	if (WARN_ON_ONCE(pte_devmap(pte) || pte_special(pte)))
+	if (pte_devmap(pte) || pte_special(pte)) {
+		if (page)
+			dump_page(page, "get_pte_pfn()");
+		dump_vma(vma);
+		dump_mm(vma->vm_mm);
+		BUG();
 		return -1;
+	}
 
 	if (WARN_ON_ONCE(!pfn_valid(pfn)))
 		return -1;
@@ -3331,7 +3338,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		total++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
-		pfn = get_pte_pfn(ptent, args->vma, addr);
+		pfn = get_pte_pfn(ptent, args->vma, addr, NULL);
 		if (pfn == -1)
 			continue;
 
@@ -3998,7 +4005,7 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		unsigned long pfn;
 		pte_t ptent = ptep_get(pte + i);
 
-		pfn = get_pte_pfn(ptent, pvmw->vma, addr);
+		pfn = get_pte_pfn(ptent, pvmw->vma, addr, pfn_to_page(pvmw->pfn));
 		if (pfn == -1)
 			continue;
 

