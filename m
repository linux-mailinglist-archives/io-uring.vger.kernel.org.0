Return-Path: <io-uring+bounces-13103-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id INQ3AeO952kWAQIAu9opvQ
	(envelope-from <io-uring+bounces-13103-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 20:11:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 68E7043E6D8
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 20:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0A98300BCAB
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41BB02DECA3;
	Tue, 21 Apr 2026 18:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="UOFrQGO2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED02334C1C
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 18:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776794650; cv=none; b=dABKcXO7Talm04sd8dz/j0ijdzYYaQe1awSZXzd6SnjBuGTU2rkbLr1eluV/PkeNPSjljGAcpN2JGacCQ7E70rJCmrlOBiVwvIS2rORNyS6mRSJZP2zrWS+0IL1eAzRvHU6eAMjGP11SL6ehPQ73wGswM6T5+K/8gbfVkNWKQNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776794650; c=relaxed/simple;
	bh=xl8N6j3b+gz3fqbPmliNSHd0SllX0JUEKr55gqsTKuk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=pK6nr8xICxgUgiNZFkqnE8u1oIVsy//bq+9YtjtCyDvxyR7B36cTtzFVipJW45UGnIYe+Bp6qTE4Ar6OLHB2G0i1A3Leb5VfFhaQV4WZT6ZzNesEO9SR7DbFLphLUCZgSJ0JT94CVAhrOSpXrcCsVMmnT/JdBrf65pa4wHriOuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=UOFrQGO2; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-692205ca402so1625005eaf.0
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 11:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776794647; x=1777399447; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QlqQWGWciZ3CiRdbLtPd61zSucf5R9oSxSQJb1tHjKY=;
        b=UOFrQGO2MvO+emIDgebJ657BUMtY4+GNFg4u5TbeK9rXhgTvb3Le9NKpoB1evX64a6
         mbBqVwlqBeS1pjJSIpWr1KtGFk/yooqIzmr/piFVdCDUTIRuYOXShjjhdm046PT4uVZy
         lsZedEVovrFvHJknPGgnqQS0toQ4i/ffM9xTSDlYk8XypOAhEWYwiBA69DlewsxGonDk
         W2KOxP15hagSUxke+iDpbxSW8hYEpym2NX3UyTgpGfk/t8dgNUjPeYtjuyu/9wDqk696
         2FwTDC+0OmGFuCC6zUf2OO7UOa477qxzCj2m1m0qmpA8t/HkduQ1lwPj2gq/PC7y8d0g
         cMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776794647; x=1777399447;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QlqQWGWciZ3CiRdbLtPd61zSucf5R9oSxSQJb1tHjKY=;
        b=CrIl5OaaagTl/74MG9MkYpce7ELimBnFZmkIKr4opQ/3H5HnT1UAyXOOrWU9WOSwdZ
         bHJ8rj+GTMjsPPktuoTpY+v+/EDGqlcyZf9pAoBqVTN6H8Ml2hxp2/RkrSH6SVg8h2S9
         QU0QRARy1Tw2td46OQ6v1RkEVB2IBH8k7yBwo1YdHCA5R4p3v758sr3qwUGWN0qSbQoC
         b5rerNeKO4ohnSm7EyfqixAGX0W2t5V4prbSxEyUoFemMUcuTyUONaVZQf4fYoAVaYBf
         Ty3yTGPqojidXamkck5mjHkTA4BxcgVkGVEs5t2t8hwjlI7bUJEEUbkgUd4saYIuELqZ
         ns1A==
X-Gm-Message-State: AOJu0YxF9GeTJ1Dk7KLUFlGJVtqZDk/t0u3HNwYFUacp6a1K08ubVtw6
	tD+lrhmECnuRzho0pgpTh4pmhLy/W+KfBcPWcsGTX4QkXNIEcvy87Vtwp0MC7mBDVBdTA/qg4Sh
	jcTj8Uzw=
X-Gm-Gg: AeBDieuWlvmN/IAzuDMuD3h/MKji5O+2BKK/1s2Bt3T1PtqW2mOpDyGd1siAf3P+43F
	pyef4icExwULbQpmM0QMNIDCbvrjBl+SzrRHIG4zsQCiXS9eG2MxS4f/J0v0lY3+mOEKJgRdJfo
	wYhk2V28tkm2l9I0L7kb6WH2NX9dJYEV3QNNXbJc1L+Nel9clEWLscGd+F6kide/cQE4lV1HbsB
	0XAZdSUlb1Qc8Z3ttrPZLNmTTez6P4lfslZFLLZzg4XOTslpV9JQXCDqbIPb5V/uX4MEosQR6uU
	XF1br0O8N2YOCQlENgbu3IgldSfOWS/ehQ6/qoI4bEhwiLRqd0TE+LTVuiM9sH79YHXwKbfjCKY
	8K+u0+wnFcyYekSki7LGdtjzqAbBq9339fTcyPXZ4SVSUsd/ymS998kqUkzbB674v3LULz132kY
	yj7/q2lXR4Idm4o3IdT2laasdrnjHETqzNHgTBfP3vcoXbBLTGfOfwQO9CfH6H5HGu1MQSjBEVL
	1G1pTvU4z3zrZTTp4o=
X-Received: by 2002:a05:6820:62a:b0:67e:2e4d:6c75 with SMTP id 006d021491bc7-69462f084a4mr10863101eaf.41.1776794647115;
        Tue, 21 Apr 2026 11:04:07 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69464ea14ddsm8661726eaf.6.2026.04.21.11.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 11:04:06 -0700 (PDT)
Message-ID: <a976cbc5-f0ca-4042-a88b-e1b947ed4c29@kernel.dk>
Date: Tue, 21 Apr 2026 12:04:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RCU warning off ublk_buf_cleanup() -> mas_for_each()
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "Liam R. Howlett" <liam.howlett@oracle.com>
References: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
Content-Language: en-US
In-Reply-To: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13103-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 68E7043E6D8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 11:47 AM, Jens Axboe wrote:
> Hi Ming,
> 
> Ran into the below running tests on the current tree:
> 
> =============================
> WARNING: suspicious RCU usage
> 7.0.0+ #16 Tainted: G                 N 
> -----------------------------
> lib/maple_tree.c:759 suspicious rcu_dereference_check() usage!

FWIW, here's what claude spits out on the maple tree usage for
ublk. Simply passing it on...

  Issue 1: ublk_buf_cleanup — missing RCU/lock for mas_for_each (line 5489)          
                                                                                     
  ublk_buf_cleanup iterates the tree using mas_for_each without holding either       
  rcu_read_lock or mas_lock. The mas_find() documentation explicitly states: "Must   
  hold rcu_read_lock or the write lock." Internally, mas_find → mas_next_slot →      
  mt_slot → rcu_dereference_check(slots[offset], mt_locked(mt)). With neither RCU nor
   the tree lock held, this will fire a lockdep splat on CONFIG_PROVE_RCU=y kernels. 

  While functionally safe (exclusive access during device release), the API contract 
  is violated. Fix: wrap the iteration in rcu_read_lock/unlock, or use
  mas_lock/unlock.                                                                   
                                                            
  Issue 2: __ublk_ctrl_unreg_buf — unpin_user_pages under spinlock (line 5431-5455)  
  
  This function holds mas_lock (a spinlock — atomic context) while unpinning         
  potentially many pages in a loop. For a large registered buffer with many disjoint
  PFN ranges, this holds the spinlock for an extended period. unpin_user_pages →     
  gup_put_folio → folio_put could also grab additional locks if the folio's refcount
  drops to zero.

  A cleaner pattern would be to collect entries, drop mas_lock, then unpin. Compare  
  with ublk_buf_cleanup which does the same unpinning work outside any lock — the
  asymmetry is notable.                                                              
                                                            
  Issue 3: ublk_buf_cleanup — kfree without mas_erase (line 5504)                    
   
  The cleanup function does kfree(range) during iteration without first calling      
  mas_erase(). This leaves dangling pointers in the tree nodes until mtree_destroy is
   called on line 5506. Not a bug (no concurrent access, mtree_destroy doesn't       
  dereference stored entries), but it's inconsistent with ublk_buf_erase_ranges and
  __ublk_ctrl_unreg_buf which both properly erase before freeing.


-- 
Jens Axboe


