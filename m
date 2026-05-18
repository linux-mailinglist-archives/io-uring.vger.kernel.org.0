Return-Path: <io-uring+bounces-13378-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mBlsI3zYCmrb8gQAu9opvQ
	(envelope-from <io-uring+bounces-13378-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:14:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ADD1569780
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 93949300A66F
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 09:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275453E4C86;
	Mon, 18 May 2026 09:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yi+h26dv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0ED3E3C4A
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 09:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779095215; cv=none; b=Sp1lHjQBjgkzs8m5h0t+WnUWXBzwOJv1iZFRp/G0APHLk7DDJII/wNX67G8JQUMKzYAdpQnLI+xQn7WbWvKKwF3WcJ0xQoAjn71JUbFNwnzN3qLoD2UFUaxHxGJlX65CjHh6hqb9Al5kw/4DRfHatxlUH8h3hUKsbMwsn0zHkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779095215; c=relaxed/simple;
	bh=+sv4jnUTyOdjjZciCJyC+lf1CirV23BI+BT8te+prnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O63RmaN0vnhjzxyjJLsvMsJAFOuQjhJ9AGY5qXQDj5u2XVkqEHdeemSA14OHstUNUQydnnJO5c9UbQ9d/EtlgKLxtdBLq+D4OvwDJ45VK3yAFMiprTqd4OuPGiJXUrdzczX5RH/b90hj6i10Zgjg++m+npOKWw7dHyX/DwvpZQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yi+h26dv; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bd85ebb368fso72778366b.1
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 02:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779095211; x=1779700011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zSl2K2WdTrcT8MX7//EVVA3HDXITKieSgfsnYmfI0m8=;
        b=Yi+h26dvDZQ2jdYVDig1OE4cz3PzmeF5K6Dlb9K30eV8DlMW50Vw4XbH3n1TZXa2KR
         lrM+MH4a4cgHcPhnNh3BVv3eozzr+u3MFV2oXZUXk8xbw51nHgVF/Tnvj+T2bBG+MwHx
         BTjVwNO3Pb19C48esnsh1cWM0DZ5awSo77UTuLh0X9b+OugX+6BfWiWaq08gma/+e5ax
         2CNrCb9tXVI75Wtb6FM4lCOMblDw3iJwtgrhZ+jkdX7k4ENpm0d5GHaxRVznpjDTQmbn
         0DKj7WJiV8v0Tk2OjfUWJzmn6Flxxcas7MzadIxCL/gjdJNAzTHM/dbTivscOUBP0A7C
         OcAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779095211; x=1779700011;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zSl2K2WdTrcT8MX7//EVVA3HDXITKieSgfsnYmfI0m8=;
        b=r1P7J5T85atlQICTl+c4Sk/yb8XTuCEwZeb44mKbHazm+N/YRPvVXraqHfkNRdDZP2
         183rEMxSN6OfuLDB4N6X/VK1mG7Waezb6alLxqLqnjVc+/IrdD/HSE7DSgXq4YznEQYq
         erK5WYix011mLD+PKxo6uuSAysbeLZlRZm654p+ONPLxdOsXlcRVxELA5/o4GFqyoeIM
         LXKb1MG1zJ5YetwwLBplg3efmC1ru1KWzM8kJxItHpnu39CoZVl4w72WQim8je/6ynEf
         4ddPa2UYH+midBiaLuYOYRfAjoY7vwdzaWPNwEEWAS1/8+Cd2IoC7x0K3ylQp1NCN3SY
         49Qw==
X-Forwarded-Encrypted: i=1; AFNElJ8D9IHTShyxMhmqhMmva6KhZno4lsjOXgd+eddwX84Rtmorpze1L/S4utQvNx4D3ytJwkSsneQdHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwyncV7sYRMDEZ3qi2iZDhcKNoAs5UANdCtPQfiDr5R10Ydl4SL
	URa8qCYUQWQee6s/NZuJrIugRoyj0qzS32r4pCH2IHh6XrMZWYzCor+2
X-Gm-Gg: Acq92OEOwRLmt3QO4W9/3zBeLjz8o6ZVX+ulCpNuGBsgVOWli3HvjI3SqLkMHfKRWKT
	m3dc4Ic+6pfrrL9S1faI9/R5GScgkCzHmY25LWjr/uR+CA8a3+yGL7Eo8wXBZOMoptbx8e0bM+D
	eoBawZPZzv0YGjqogDa0szWiVw8jJL7TuyHjjD0j8g7soa3s9I+9CYdn5I302UJwJD8BXO6aNUW
	tRQBZq68ZRSJbDNif5XoivqjE9cjHEd8rziEsTJVlis7O8Y3wAz5GUAbLIyqPJ7IgYHzBhiy27/
	ktEcO3KT/BqjwggtCb+eC4AHV5mkGC9A7utPI9KVMgtiK6GtjM7BJCw00SRxCY4Q1a5lyn559zE
	D653aEdqghNKrC+AqMrXJ2vz+H4WICBha1fR1C4ZmukdLvETjFkuS4PNjvvnw0MzxPTN2idNa7U
	qyLNQkI+5aQTST0buUmwR1Rn5V9zEbAWz5XG2VcxLGaGAjfKEhbB7P8DZ7fPC4nxmQYbuupZOyk
	Sw0dp/4buz3Ew4t0pO0BeptMFiKe9nknlkZGSkRPLSqL/eXZBUapcsfBvo=
X-Received: by 2002:a17:906:6185:b0:bc4:b9f5:fe27 with SMTP id a640c23a62f3a-bd51780c8acmr759171166b.10.1779095211030;
        Mon, 18 May 2026 02:06:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:6e9b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4e57cb8sm535358566b.50.2026.05.18.02.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 02:06:50 -0700 (PDT)
Message-ID: <9f3f3dc7-1c52-49b6-91d5-046f1fc7b2a8@gmail.com>
Date: Mon, 18 May 2026 10:06:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] fuse: wait for aborted connection before releasing
 last fuse_dev
To: Bernd Schubert <bschubert@ddn.com>, Berkant Koc <me@berkoc.com>,
 Greg KH <gregkh@linuxfoundation.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: "security@kernel.org" <security@kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>,
 "linux-fuse@vger.kernel.org" <linux-fuse@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>, fuse-devel <fuse-devel@lists.linux.dev>
References: <20260517095846.fuse-iouring-uaf.dc5f5dbb71dc@berkoc.com>
 <2026051703-equinox-multitude-91e2@gregkh>
 <20260517-fuse-uaf-cover@berkoc.com> <20260517-fuse-uaf-patch2@berkoc.com>
 <08d3f6e0-7745-4084-995a-95ddb77f7f11@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <08d3f6e0-7745-4084-995a-95ddb77f7f11@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9ADD1569780
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SEM_URIBL_FRESH15(3.00)[berkoc.com:email];
	SUSPICIOUS_URL_IN_SUSPICIOUS_MESSAGE(1.00)[];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	BAD_REP_POLICIES(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13378-lists,io-uring=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,vger.kernel.org,kernel.dk,lists.linux.dev];
	RCVD_TLS_LAST(0.00)[];
	R_DKIM_ALLOW(0.00)[gmail.com:s=20251104];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	NEURAL_SPAM(0.00)[0.343];
	RCPT_COUNT_SEVEN(0.00)[11];
	REDIRECTOR_URL(0.00)[aka.ms];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=1];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_SPF_ALLOW(0.00)[+ip4:104.64.211.4:c];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,aka.ms:url]
X-Rspamd-Action: no action

On 5/17/26 16:00, Bernd Schubert wrote:
> On 5/17/26 14:59, Berkant Koc wrote:
>> [You don't often get email from me@berkoc.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>
>> From: Berkant Koc <me@berkoc.com>
>>
>> fuse_dev_release() on the last fuse_dev of a connection calls
>> fuse_abort_conn(fc) and then immediately fuse_conn_put(fc). For io-uring
>> backed connections fuse_abort_conn() reaches fuse_uring_abort(), which
>> runs fuse_uring_teardown_all_queues() synchronously once and then
>> schedules ring->async_teardown_work to run after
>> FUSE_URING_TEARDOWN_INTERVAL (HZ/20). If the synchronous pass left
>> queue_refs > 0 the work owns further accesses to ring->queues[*]->
>> ent_avail_queue and ent_in_userspace entries.
>>
>> Meanwhile fuse_conn_put() can drop the last reference and arm
>> delayed_release() via call_rcu(). After the RCU grace period
>> delayed_release() calls fuse_uring_destruct(), which kfree()s the ring
>> entries on each queue->ent_released list. The previously scheduled
>> async_teardown_work then runs and walks per-queue lists that contain
>> freed entries, producing a slab-use-after-free reported by KASAN at
>> fuse_uring_teardown_all_queues+0xee reading ent->list.next from a
>> freed kmalloc-192 region.
>>
>> fuse_wait_aborted() already exists for this purpose: it waits on
>> fc->blocked_waitq for num_waiting to drain and then calls
>> fuse_uring_wait_stopped_queues(), which waits for ring->queue_refs to
>> reach zero. Call it between fuse_abort_conn() and fuse_conn_put() on
>> the last-device path so the io-uring teardown work has fully drained
>> before the connection can be torn down.
>>
>> Fixes: c090c8abae4b ("fuse: Add io-uring sqe commit and fetch support")
>> Cc: stable@vger.kernel.org # 6.14+
>> Tested-by: Berkant Koc <me@berkoc.com>
>> Signed-off-by: Berkant Koc <me@berkoc.com>
>> ---
>>   fs/fuse/dev.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index 5dda7080f4a9..7d9c06654a98 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -2566,6 +2566,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
>>                  if (last) {
>>                          WARN_ON(fc->iq.fasync != NULL);
>>                          fuse_abort_conn(fc);
>> +                       fuse_wait_aborted(fc);
>>                  }
>>                  fuse_conn_put(fc);
>>          }
> 
> I might be wrong, but I don't think it is possible, Maybe Pavel or Jens
> could help (added to CC). Basically as long as
> fuse_uring_async_stop_queues() runs we do not have completed all
> io-uring commands via io_uring_cmd_done() and as long as we do not have
> completed these io-uring commands.

If I understand the question right, yes, fuse io_uring cmd requests hold
a reference to the fuse file, so until you complete them the file will
not get released.

-- 
Pavel Begunkov


