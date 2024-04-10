Return-Path: <io-uring+bounces-1492-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 064D689EAB3
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 08:20:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3A1EBB223D3
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 06:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43475282FE;
	Wed, 10 Apr 2024 06:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DRH5op6+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0jV/eoo4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DRH5op6+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0jV/eoo4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668ED20304;
	Wed, 10 Apr 2024 06:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712730044; cv=none; b=O9Mp0poj9kWHym7tiVHOLGZlTwmcqgS/NyAqeVfHRiOUP+NcK4+pLXbKi2i48A73Fv6AUhj2Aty/8beISjwEwfpbbdmLdrBV2jmd2gbvpsxIg9l1YQzxkVWTLD1lU7ohqwuuW5rsdUYi1E74VvozmIHXKeakYwGJrVl10DnvfGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712730044; c=relaxed/simple;
	bh=SVgnyvJn4+dftj5N9qiNFUfNLaC+N6iSxocInF85y/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JpTyfPXzWkiF/JUek0khNCnccF2tIkjLKMedKyK21Csq42rDMlIuzkHLrm3KmMT01PRftCn1sIFFcOABCnED/r3bhHHAkgXQ5thCR0cnqJjqgwb8NknwuBQYuk48kFIqqAI7XzICE7Pm3jDXN6/w1I4UGF2Qeuiep8Rez8OQopk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DRH5op6+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0jV/eoo4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DRH5op6+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0jV/eoo4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A4D3349E5;
	Wed, 10 Apr 2024 06:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712730040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJIujaH3RXIktcRv88URJI4c3MW1XPtMbHZWqI5VmXc=;
	b=DRH5op6+qgu/ZbeaZUaYpnIYWqjeWpHK8OW0+kwvqDCMEwaguq5aqaXafgAjwJ6zywhusF
	tsgFsWgaCMMY4NaTEaGk3lDtHCR73mjQ4SRA1LnqLj9EF0l+PnSJ2BlijBLHcS98VKUP8t
	Vf4bNVGD5TMPNXoHOH52Hod45ruzXX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712730040;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJIujaH3RXIktcRv88URJI4c3MW1XPtMbHZWqI5VmXc=;
	b=0jV/eoo4drBjtHKjxE/GtnE1W1+NVg3WllILQl+VLv9gNYfTXrOGjwpUFYpLOwg0GRsGjF
	4Wxv4HCZCDpVodDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712730040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJIujaH3RXIktcRv88URJI4c3MW1XPtMbHZWqI5VmXc=;
	b=DRH5op6+qgu/ZbeaZUaYpnIYWqjeWpHK8OW0+kwvqDCMEwaguq5aqaXafgAjwJ6zywhusF
	tsgFsWgaCMMY4NaTEaGk3lDtHCR73mjQ4SRA1LnqLj9EF0l+PnSJ2BlijBLHcS98VKUP8t
	Vf4bNVGD5TMPNXoHOH52Hod45ruzXX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712730040;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJIujaH3RXIktcRv88URJI4c3MW1XPtMbHZWqI5VmXc=;
	b=0jV/eoo4drBjtHKjxE/GtnE1W1+NVg3WllILQl+VLv9gNYfTXrOGjwpUFYpLOwg0GRsGjF
	4Wxv4HCZCDpVodDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CECBE13691;
	Wed, 10 Apr 2024 06:20:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id InaALLYvFmaJGQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 10 Apr 2024 06:20:38 +0000
Message-ID: <94d6d88b-b0e7-491d-94e8-dc9e5fba5620@suse.de>
Date: Wed, 10 Apr 2024 08:20:37 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] block atomic writes
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, Pankaj Raghav
 <p.raghav@samsung.com>, Daniel Gomez <da.gomez@samsung.com>,
 =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier.gonz@samsung.com>, axboe@kernel.dk,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
 martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
 brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
 ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, nilay@linux.ibm.com, ritesh.list@gmail.com
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
 <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
 <f3c1d321-0dfc-466f-9f6a-fe2f0513d944@oracle.com>
 <ZhQud1NbO4aMt0MH@bombadil.infradead.org>
 <ZhYQANQATz82ytl1@casper.infradead.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <ZhYQANQATz82ytl1@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[30];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	R_RATELIMIT(0.00)[to_ip_from(RLusjj3u5c53i6g8q6enupwtij)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[oracle.com,samsung.com,kernel.dk,kernel.org,lst.de,grimberg.me,linux.ibm.com,zeniv.linux.org.uk,redhat.com,suse.cz,vger.kernel.org,lists.infradead.org,mit.edu,google.com,kvack.org,gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Score: -2.79
X-Spam-Flag: NO

On 4/10/24 06:05, Matthew Wilcox wrote:
> On Mon, Apr 08, 2024 at 10:50:47AM -0700, Luis Chamberlain wrote:
>> On Fri, Apr 05, 2024 at 11:06:00AM +0100, John Garry wrote:
>>> On 04/04/2024 17:48, Matthew Wilcox wrote:
>>>>>> The thing is that there's no requirement for an interface as complex as
>>>>>> the one you're proposing here.  I've talked to a few database people
>>>>>> and all they want is to increase the untorn write boundary from "one
>>>>>> disc block" to one database block, typically 8kB or 16kB.
>>>>>>
>>>>>> So they would be quite happy with a much simpler interface where they
>>>>>> set the inode block size at inode creation time,
>>>>> We want to support untorn writes for bdev file operations - how can we set
>>>>> the inode block size there? Currently it is based on logical block size.
>>>> ioctl(BLKBSZSET), I guess?  That currently limits to PAGE_SIZE, but I
>>>> think we can remove that limitation with the bs>PS patches.
>>
>> I can say a bit more on this, as I explored that. Essentially Matthew,
>> yes, I got that to work but it requires a set of different patches. We have
>> what we tried and then based on feedback from Chinner we have a
>> direction on what to try next. The last effort on that front was having the
>> iomap aops for bdev be used and lifting the PAGE_SIZE limit up to the
>> page cache limits. The crux on that front was that we end requiring
>> disabling BUFFER_HEAD and that is pretty limitting, so my old
>> implementation had dynamic aops so to let us use the buffer-head aops
>> only when using filesystems which require it and use iomap aops
>> otherwise. But as Chinner noted we learned through the DAX experience
>> that's not a route we want to again try, so the real solution is to
>> extend iomap bdev aops code with buffer-head compatibility.
> 
> Have you tried just using the buffer_head code?  I think you heard bad
> advice at last LSFMM.  Since then I've landed a bunch of patches which
> remove PAGE_SIZE assumptions throughout the buffer_head code, and while
> I haven't tried it, it might work.  And it might be easier to make work
> than adding more BH hacks to the iomap code.
> 
> A quick audit for problems ...
> 
> __getblk_slow:
>         if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
>                          (size < 512 || size > PAGE_SIZE))) {
> 
> cont_expand_zero (not used by bdev code)
> cont_write_begin (ditto)
> 
> That's all I spot from a quick grep for PAGE, offset_in_page() and kmap.
> 
> You can't do a lot of buffer_heads per folio, because you'll overrun
>          struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
> in block_read_full_folio(), but you can certainly do _one_ buffer_head
> per folio, and that's all you need for bs>PS.
> 
Indeed; I got a patch here to just restart the submission loop if one
reaches the end of the array. But maybe submitting one bh at a time and
using plugging should achieve that same thing. Let's see.

>> I suspect this is a use case where perhaps the max folio order could be
>> set for the bdev in the future, the logical block size the min order,
>> and max order the large atomic.
> 
> No, that's not what we want to do at all!  Minimum writeback size needs
> to be the atomic size, otherwise we have to keep track of which writes
> are atomic and which ones aren't.  So, just set the logical block size
> to the atomic size, and we're done.
> 
+1. My thoughts all along.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


