Return-Path: <io-uring+bounces-13566-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qI+8EIQZGmo+1ggAu9opvQ
	(envelope-from <io-uring+bounces-13566-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 00:56:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9352E609872
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 00:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6FD030488CB
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 22:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B813A960E;
	Fri, 29 May 2026 22:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="UwuJ6v5W"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7596A388E57
	for <io-uring@vger.kernel.org>; Fri, 29 May 2026 22:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780095252; cv=none; b=qBbWG0H5EoNVQqay8P44t7rbYubMJuxLAwAjhwTTVSY84Yxe2Fh4YBXMx/buPSDI5kCmwnrAhpHCvrk8+Y6pH19RHDd9F5dep4CsX+KS5bQ+Gdo+7WIVYKPMDXBrE7KrGMSP2wJ4gxnuQKVLJ9IHhIIjYeJ2EK8L6gUV0wMeAQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780095252; c=relaxed/simple;
	bh=VqUDarAfMpodcO2RjjjUxeiD3RKyxcs+yKqS/ZiCUh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HvuoFTW5A7eBgCk003KrRWov3oT/0rzGhypAkTSAS6GTTJ+r4B/Pu4ZGuVeVhPftKICtSiiKBT6Ti+CYMPMZ8bQSps390jv+jl9ElCP0X6LXdjWR+GD+GPj0clQby2AOJOn7yULWot3YYQVXvU7iivUpsg3Io1jNQ1BYHCpWQKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=UwuJ6v5W; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64TMCHFg1862262
	for <io-uring@vger.kernel.org>; Fri, 29 May 2026 18:54:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=GOZu
	5NR42SpEsku8Ns1Xem+A9XCgYdtBxKbxW3wb/Q8=; b=UwuJ6v5WZJ0OeCqb38nZ
	HxEw2K5Cim53nr0/UyKGLlTxJ8iXCu7a1kzXow6FM8Jm2xVS/jS6fXhXw7NmrG+i
	6Ynjd0MEmmJHxai0llD5mTU106Dx+HBK2yTwvKbRxKZ0Gi3l2kG4Evjxx9XH5tnf
	U6xdc7bZuNMv8AdFXqojAJecp7t44lFRQjuiCn2fRWu3hGsG/u83f6ivFjj67M93
	DssaA27UFx5/Z6enDS2FA5FfbGcpreXwLfICcVDyOb0KSG3OGeelkvVpmMdzfyVV
	qhIQRMNBFt+9suOoW4qapI52ys14Wg13IPwJ73GHax4AgwXM6/Y2JPKDy3tT63tc
	zQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4efh64s4vw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 29 May 2026 18:54:10 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8ccdcc89495so42066186d6.0
        for <io-uring@vger.kernel.org>; Fri, 29 May 2026 15:54:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780095250; x=1780700050;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GOZu5NR42SpEsku8Ns1Xem+A9XCgYdtBxKbxW3wb/Q8=;
        b=U6nraaMFKj4OEH7tJWJkgCtYDfJlAekOY7FYp3dlEZOzcRzK0mkWXQPgHAHu3qQwzi
         gL38aP+xYHVDe78YExWBxujFZrhMXTng4QaRPnA394T0T7X47YBek2bjKvwzV261LlrG
         wHdu6oIb6dwTYYj9VeczSR+D6IQ7534LX5D4r020I3JTO0TaGM20GUEEyGJtOOOtI233
         LoVJQ3msZtgUFbbPUjVOWFGyKnLjvzdaUjN/xYrdHwL1VMtW/Bw1rHTeI1JpdMPUFs1/
         +WtxuPHMpgiQ6Kf7d3fsRhSw0Zx0PLy7I/djbLu3cyZ+qlb1R7YTMssyRJohK7bSEq5C
         usFA==
X-Forwarded-Encrypted: i=1; AFNElJ+t/zCeYKeQLOehAKUuWPGAnV4tAOL5WU6CRDb2jT3+0NrSX31QpzV8Q1snYxIVVWQwu0IATsBA5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyYVFHC1Diu0mkzhzSyTKiS5JK8oOTopWnqTmLskXDUdgO8P3l
	mCqVbVjvlaFmLjCZMo2eDIBmg5QegBOjaYeFbK/YwWI5vXcXNWgOaIaEYJLZ2f9u/9kYAIhNhRJ
	MH5lQeGKBHhtJnBgTS6UFSH87G2v9P6pxREaCgvvyCGodEgrhWObU328M
X-Gm-Gg: Acq92OG/uzsUvD9cLanUXE16OpNKSJLi5zOcLrARlxGyrLrJmaSTggtyNrXuJAU42BC
	we35yGhtaW9DPea7AUf3MM5SvyyPnneyn2pjxYXGIcY02R6+OxEj6mGuEob50aBAR8jVzTsUc4Z
	8oVxR0oa8REtiaJBAe/nvNJNeEpnmEgCXR+xTA/tPOMTH8kaK5M34L+J9hg/di8Gl2zQ6zlUsfo
	ErCizUQ9FhfOt0YGa8LD1v3YSPEzPJs+ovU/brTMdv6fu3mSeo9cl0TWtLg9K8ixw8RDtNwd75j
	ZXc1xSiQELiuo+U4xJOL0J5QSDPiz+WfPw/2RPFSguFXEG6s+579Vw6L26S9SqIth+SqflKuAUG
	nohR3cLgwB0CvqILcr6XBmjo/c9KyQiXqD1QsDPZ0mwWgEfh+LBwDmDDhk+2Q6J3QkZ4TkroSYq
	37FCLL4v20F59WTqQcjh1csC+Ubw==
X-Received: by 2002:a05:620a:7005:b0:911:d96d:139 with SMTP id af79cd13be357-9152f91aae8mr628980885a.11.1780095249714;
        Fri, 29 May 2026 15:54:09 -0700 (PDT)
X-Received: by 2002:a05:620a:7005:b0:911:d96d:139 with SMTP id af79cd13be357-9152f91aae8mr628978785a.11.1780095249321;
        Fri, 29 May 2026 15:54:09 -0700 (PDT)
Received: from ?IPV6:2600:4040:974e:fe00:c8bb:325f:9d37:a5f? ([2600:4040:974e:fe00:c8bb:325f:9d37:a5f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91532628f87sm335923385a.35.2026.05.29.15.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 15:54:08 -0700 (PDT)
Message-ID: <fb59cca8-28b0-4231-a109-a6ae0ea12a03@columbia.edu>
Date: Fri, 29 May 2026 18:54:07 -0400
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
To: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
 <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
 <ahg55Ei8Fc3iRsnA@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <ahg55Ei8Fc3iRsnA@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=JJQLdcKb c=1 sm=1 tr=0 ts=6a1a1912 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22 a=lO0XnYq6BgjnjRCXdOAA:9
 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: GXtkCDFv-fgCsETjUtIFNC8Aw_6bLjSj
X-Proofpoint-GUID: GXtkCDFv-fgCsETjUtIFNC8Aw_6bLjSj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDIyNyBTYWx0ZWRfX9nsQlg4LxTRQ
 XDVMJ1C8U02K3rqRj3G7bFIXHQoQCGLcj2lyQPZVGg0eitqLA+lu2ttK5i/lvPO+/9p0nN8y6nV
 driwbCUltTxNau8QlXHfjzeXS5XR5+IKOTEFZlFwFeSe4PncNGG2PXhpPO9S5/ruan3OOxmJ985
 QhB6Ev146q02GkCTKIeBuhDaWnrDbLDCA91LWYn8yol+FWLXIz+LBB+4xNhjI7tMVW/dj+OZA8d
 4f8Jxep6PYKN3XrylDD255/8v7a1yR9O0LwSYLz3Q1AzRbafpdtV7h+PVsfOcWec5Oxszsy0Pfv
 xzggnA8RKxeDWdNsGN921/dGt+5XJHy+nTXFlpjHvPE9bYwqojqp6mytZwSv1EqE1hUEXUcWppS
 8FaMWCpkwpGxVI1JFcwx6PTguridX2QSO13X+sfeO64tGGSRy01WWAd8WkbYDelF62fEpAYg217
 ZhfL6x/VWmNflmWlEBQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11801
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=10 suspectscore=0
 lowpriorityscore=10 adultscore=0 impostorscore=10 clxscore=1015
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2605290227
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[columbia.edu,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[columbia.edu:s=pps01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13566-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[columbia.edu:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tz2294@columbia.edu,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 9352E609872
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/28/26 8:49 AM, Christoph Hellwig wrote:
> On Thu, May 28, 2026 at 11:22:37AM +0200, Jan Kara wrote:
>> Overall this makes sense to me. In particular I agree it makes sense to
>> move the file read/write helpers into fs.
> 
> I disagree very strongly.  Mixing default implementations with the
> higher level APIs is a really bad idea and leads to people taking
> stupid shortcuts and other layering violations.

fs/read_write.c already contains some of these "generic" function
implementations, including generic_write_checks(), which is called by
generic_file_write_iter() in mm/filemap.c. Right now the two files are
unnecessarily interdependent. I do think fs/read_write.c is the natural home
for these functions.

> Splitting up filemap.c makes sense, but I'd rather keep the generic copy
> into and out of the pagecache code with the MM infrastructure for it,
> as it is not VFS code, and making that clear to anyone touching the code
> is important.

About half the code moved is implementing direct I/O or multiplexing between
page cache I/O and direct I/O. It definitely shouldn't be in the page cache,
and I do think it is VFS code. The one exception I see is
generic_perform_write(), which is analogous to filemap_read() and should stay
in filemap.c (and probably be renamed to something like filemap_write()).

