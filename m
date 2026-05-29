Return-Path: <io-uring+bounces-13565-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eC7JMIMUGmrj1AgAu9opvQ
	(envelope-from <io-uring+bounces-13565-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 00:34:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44D0D6095FE
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 00:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 71A9F30EF99E
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 22:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98D002DA749;
	Fri, 29 May 2026 22:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="eSTg8+oJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21B03C0A12
	for <io-uring@vger.kernel.org>; Fri, 29 May 2026 22:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780093600; cv=none; b=RbgibduaZK4tp6Z5zXYlOjTHu7gOncIz19JvFCAjpxtWZdkIspa8/GKaltHZKqhKOmSFEv4u8lz2bor26NA/4dwgmtNdbOLL5Qru5cfQ8HJsnbMVaRr2QogkTGzpfpBCSJPuWJ8Jo8XhUcMpNKszYwrBQRL9mF9x+fA0BawmHPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780093600; c=relaxed/simple;
	bh=ENbFljKVw68AZqog/6x3mb9fPnIVpOTl56N7EZpGlqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lQp3Uxv6C3uPdWyG+VEnoo66I4rB2Fv46C3tEJqWL68/WizsJ6rEomcJr9ZiUtPL79ghlk/1n+Zb3YYztm2b4azDG81r+oq/6n2LVvVXp9NzWNI3n3v0GE2KOTVfIZFPHX4GasZrW6M/EBAbyt3OIfLghUtCAmQgE88M/eed1hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=eSTg8+oJ; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64TMEMDq1884010
	for <io-uring@vger.kernel.org>; Fri, 29 May 2026 18:26:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=iZ/C
	vHIaEtxesqHd176lUmCe2CW9FRR63TiqxgWScco=; b=eSTg8+oJ5fRfpIsx6Tcq
	92PnYHoBuV3eXLxsANRD4phElJOVL5OrwGQgCP77zxwra/FJ30+BKPxbno6PYIIp
	5faeDnrGsEhAaigVZ7MBPyHYqiB3nkH6XrhhfogAi7EAEk2vaZ9IeSxT8CondLr7
	jqJMA5R/00D8iXke54BONNZvImIY+LumJP6u79cKGBhJJ2R+IZI7De0/CNGwfz1N
	ns790QCfOjIVyGPyf7xXcJ8wj3/tGdHl3rB3XwyKzLsbqUIFVrXiB4Rsm6AREvGP
	syQ4v6JgLIluuEfGsF9GMof5QRRNI5Qch2IOEwBqpN5zOehwtmi/QVYxaIhKdF2f
	2Q==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4efbsk409u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 29 May 2026 18:26:37 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-90cbd806004so2908881085a.0
        for <io-uring@vger.kernel.org>; Fri, 29 May 2026 15:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780093597; x=1780698397;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iZ/CvHIaEtxesqHd176lUmCe2CW9FRR63TiqxgWScco=;
        b=Ov+z7QDuDUw22YH646gxHIw5CLcx9WPRqqv28fcyHRwCIEdvoVeXXeui/OY5xSHR0e
         O9BttXMg6u3ZRrpsPNaczhVdf2YH0xRLwYfmASz9NEXTfqz03puiY+0DdLmFhI7U2/qJ
         VrZjNlHoKIyG9gPfqz0k1RfQKQnfSo7sZQztvmgYa0SQhPix4t5cE16W/xR6gfDFfwHn
         cZMV8XTWYZlfLlpQuCr349kJoyX35RsD7mtNny9/ZHvJtmMokO12KAaI5+aOebbYGshn
         6tZw+WHQUDaBLSwwAfBVNFw7p2q6geVLNbL0oN5RGQ8D++XXSInC/hmtRNg2FoVFGPS+
         2vAQ==
X-Forwarded-Encrypted: i=1; AFNElJ+mMcYgyhCBqc12+RfxJLbxoRj8Wq8UDzDYdwQecUr78B1opUmKPxemhuHby2ttOULeRKu2nP7NjQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy9OdC6Ld54k6zIIR+yG96lhSHvdGDI3ZEXIty8tYMhH4jEB71
	BlRyS5uFiyXGLcHI5qu/GfwidFA4DaWbKzCf9b+v1f/dPQPeyL4EJ6IYvNxAMGFmsg25gF79qMC
	HukHF69mzeOk9mh1FztPJPuU/PEAT60Ns1lcS0ggHwp0BCK/v0jWLIbam
X-Gm-Gg: Acq92OE9eTjah8waSP65ZlaTcT67ok4YUKUmaLwqJwujjBRJVs7D7LRGjviA/rhp+fo
	5E7lW+6qADgo51HShjcGhvz9+LpYF0yxkfQr4qelMGpJocgnH+ra6IYLZwZYGG/Abia9O3D9iwS
	hr2xSjnWJ6pmfZ1PfuYYW+gKPiM+yuptt8JZRFqmQbXvlNp5yhQ2tdNkzRshAh5pJSl/Bb85EzL
	yrfvfHB0uCXQUwqEGv3GDRs151U8AQfzPxp3TlKwe2HNgGPN9AHwTsBrdYw44jDj0ZatC+yTbK/
	tMkcyMxSnne5ldY2pSZwNCI861k3LYYZr5LfaPSkpj6+Rnn7VwWByo9tC2VKO1ODCrtT6ISlefX
	HLqiLuEsw59TqfiLVL520iXA6KP0f/i5o9I/ljxsFA5uwEr9LqxZHswuWgJ1aJ5B2dpqhVzDaTQ
	Bu3abEvJPa56Zfib6tevod6XUbIQ==
X-Received: by 2002:a05:620a:2a0e:b0:915:2b21:c74e with SMTP id af79cd13be357-9153d9776camr269384185a.24.1780093597066;
        Fri, 29 May 2026 15:26:37 -0700 (PDT)
X-Received: by 2002:a05:620a:2a0e:b0:915:2b21:c74e with SMTP id af79cd13be357-9153d9776camr269379685a.24.1780093596656;
        Fri, 29 May 2026 15:26:36 -0700 (PDT)
Received: from ?IPV6:2600:4040:974e:fe00:c8bb:325f:9d37:a5f? ([2600:4040:974e:fe00:c8bb:325f:9d37:a5f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915325fae79sm323170185a.26.2026.05.29.15.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 15:26:36 -0700 (PDT)
Message-ID: <205bb690-2874-47c3-b352-33ee96026196@columbia.edu>
Date: Fri, 29 May 2026 18:26:35 -0400
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
To: Jan Kara <jack@suse.cz>
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
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDIyMiBTYWx0ZWRfXyV1CX2Ey/VGP
 ctwVH5dk5w9eDRTjOLnhLpcpqeAMkf4x9gL4hICeJCYSy1TfT4xeM8QuVykIF2IvV3pknJKAHMe
 cUjQoSqe0BDOt/e0hun5rGiAv7YEr0ih4AJnYc4CS+fLEGSv8AoU93GYwlpoGs+wumqs2OjAUKf
 EGZtcgggTLjbX+or429qCRS8+lcmTIAjwvthoSOU2WaEzhMyJ2+B+7HCMj3pfWRQePhdBCfQsXM
 QXWZeVpSH/SEZuSHai8k544GAhs4C63hJHAGIK+aZISuX9IfUtc3pnm4yWJs8IZ53YlY0OgKSFr
 PEFR79aHmBYfZZCCYGFeAqyHmyhHoZnVgs+2sSiug4y+ZUVhPIgzBXQ8+6FDezWcIHfFU06tqam
 E+Td+Yc1WUMTHnxGrt9kqKCC6298EVY1oK3ClU1cwDhjxmx5eZ6LCLlE99bp7Ex0EgqSligEIW0
 piNDQJ9A6UYBgvcK/eg==
X-Proofpoint-ORIG-GUID: 6Uuq3HxiREQtL0EVDwgVy747PQnVu9mC
X-Authority-Analysis: v=2.4 cv=SZ/HsPRu c=1 sm=1 tr=0 ts=6a1a129d cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22 a=aRezoWbpNT72RPsyBYsA:9
 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: 6Uuq3HxiREQtL0EVDwgVy747PQnVu9mC
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11801
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 phishscore=0 lowpriorityscore=10 spamscore=0 suspectscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 clxscore=1015 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605290222
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[columbia.edu,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[columbia.edu:s=pps01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-13565-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[columbia.edu:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tz2294@columbia.edu,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 44D0D6095FE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/28/26 5:22 AM, Jan Kara wrote:
> On Wed 20-05-26 16:48:51, Tal Zussman wrote:
>> mm/filemap.c has accumulated additional infrastructure over the years
>> that is not directly related to the page cache. It is currently nearly
>> 5000 lines long. This series splits out the folio bit-lock and wait
>> queue code into separate files, and moves the VFS-level
>> generic_file_{read,write}_iter() family of files to fs/read_write.c, in
>> order to provide better separation of concerns. This also slims down
>> mm/filemap.c by ~1000 lines.
>> 
>> The folio wait infrastructure is centralized in mm/folio_wait.c and
>> include/linux/folio_wait.h, with functions moved from mm/filemap.c,
>> mm/page-writeback.c, and include/linux/pagemap.h. Afterwards, the code
>> is cleaned up a little, with functions and data types renamed to refer
>> to folios rather than pages.
>> 
>> generic_file_{read,write}_iter() implement the VFS-level read/write path
>> for filesystems, including support for direct I/O. These functions and
>> their helpers are moved to fs/read_write.c, along with other VFS-level
>> read/write functions. dir_pages() is also moved to include/linux/fs.h.
>> i_blocks_per_folio() is not moved from include/linux/pagemap.h, as it
>> requires folio_size(), which is not currently available in
>> include/linux/fs.h.
>> 
>> No functional change is intended.
>> 
>> Note: I have additional cleanups to mm/filemap.c ready to go, foremost
>> among them centralizing on the filemap_*() naming convention and making
>> the exposed page cache API clearer and more consistent, but I've split
>> these patches off from that in order to avoid sending these logically
>> separate patches to ~60 maintainers.
> 
> Overall this makes sense to me. In particular I agree it makes sense to
> move the file read/write helpers into fs. Regarding the page waiting bits
> it makes some sense to me as well although there it's more of "I don't
> really care" opinion so let's see what Matthew and others think...

Sounds good, thanks. For the folio wait/lock code, my reasoning was that
it's used well beyond the page cache and independent of it, so there's no
reason to clog up filemap.c with 700 lines of infrastructure for a more
generic interface (and splitting up pagemap.h a little is a nice bonus).
But yes, let's see what Matthew thinks.

Thanks,
Tal

