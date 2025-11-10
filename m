Return-Path: <io-uring+bounces-10492-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C84D2C4518C
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 07:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B6A444E5093
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 06:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B1FC2E8B95;
	Mon, 10 Nov 2025 06:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="AW4wZ5WD"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9141E9B3A;
	Mon, 10 Nov 2025 06:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762756623; cv=none; b=IHFCsvMPcxDDCYcFX2IMWSRxzVobN/Oggp04AzTA4UX6ygEIAHNjl4fVIsrLArvJeg1U0ndLlRHCfClPY7KRV/tqrZj9W/c5KND+ccLfXb7ePd0riSXALYtPg91AFYBmxSpSO3uT7BAiT1mjm0bJjtftH0+RpEFadzpMGqOino0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762756623; c=relaxed/simple;
	bh=1r88jEXLw6cXgc6sjVxdPVGby5G10pB+EnPT36bdWG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYA6lm7kekxcwJPTqL7suFqrach5O/46rmjKeQ8V7tqxOmE5TTxVDdkijDei3bcQ4izXwVU7EIZct94spluWw5IVJ5kfYDSA6Vyc8Yg+fqoRYTzloM/JxiEwkgBwlBGDieF1ZUYF38L7rmLHW+SRznRRSzujTso8YY0mm3pwqh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=AW4wZ5WD; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t8w4a85+qrOYPEQgAni3nALLl8mIEI0OUv3X2VHdpX0=; b=AW4wZ5WDtesUhXx0P7Ez1nVTPm
	Fe742Svl0UGX6ophZZfcTi89Kw0e5OWDQdQOr5N8EOBeiFJuwPHtnC+Svr5Yy7sraABp55bJGTK9h
	vrKMpgNnLFYlGw/1D8nc+6cwnWb8acONIZ3MvDbWR/cuNEcN+ffY56ajdBpf+grAUl0CnktPlwPtm
	D+lQoWjo1y4XbwuAsf7lJkxIB9LtokOqoHhWL97/3PdERgEDj/5VE0hXGwplRfgyOWdXHY8V6d+87
	IPypaWtzutfKJQj7t+JJN3+s2mnkk3qAeI1Cg7GqRwiTIHMbcjj8FGJe9eKMkOsNo8tWS5vtXY8iw
	27nvZW+Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vILWM-00000000pYB-0lQe;
	Mon, 10 Nov 2025 06:36:58 +0000
Date: Mon, 10 Nov 2025 06:36:58 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk,
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
Message-ID: <20251110063658.GL2441659@ZenIV>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk>
 <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Nov 09, 2025 at 02:18:04PM -0800, Linus Torvalds wrote:

> @@ -143,7 +162,7 @@ getname_flags(const char __user *filename, int flags)

> -		const size_t size = offsetof(struct filename, iname[1]);
> -		kname = (char *)result;
> -
> -		/*
> -		 * size is chosen that way we to guarantee that
> -		 * result->iname[0] is within the same object and that
> -		 * kname can't be equal to result->iname, no matter what.
> -		 */
> -		result = kzalloc(size, GFP_KERNEL);
> -		if (unlikely(!result)) {
> -			__putname(kname);
> +		kname = kmalloc(PATH_MAX, GFP_KERNEL);
> +		if (unlikely(!kname)) {
> +			free_filename(result);
>  			return ERR_PTR(-ENOMEM);
>  		}
> -		result->name = kname;
> -		len = strncpy_from_user(kname, filename, PATH_MAX);
> +		memcpy(kname, result->iname, EMBEDDED_NAME_MAX);
> +
> +		// Copy remaining part of the name
> +		len = strncpy_from_user(kname + EMBEDDED_NAME_MAX,
> +			filename + EMBEDDED_NAME_MAX,
> +			PATH_MAX-EMBEDDED_NAME_MAX);
> +		if (unlikely(len == PATH_MAX-EMBEDDED_NAME_MAX))
> +			len = -ENAMETOOLONG;
>  		if (unlikely(len < 0)) {
> -			__putname(kname);
> -			kfree(result);
> +			free_filename(result);
> +			kfree(kname);
>  			return ERR_PTR(len);
>  		}
> -		/* The empty path is special. */
> -		if (unlikely(!len) && !(flags & LOOKUP_EMPTY)) {
> -			__putname(kname);
> -			kfree(result);
> -			return ERR_PTR(-ENOENT);
> -		}
> -		if (unlikely(len == PATH_MAX)) {
> -			__putname(kname);
> -			kfree(result);
> -			return ERR_PTR(-ENAMETOOLONG);
> -		}
> +		result->name = kname;


FWIW, I would take that part into an out-of-line helper - it does
not need flags and it doesn't really need to bother with
free_filename() on failure - that can be left to the caller,
where we would have
	len = strncpy_from_user(kname, filename, EMBEDDED_NAME_MAX);
	if (unlikely(len == 0) && !(flags & LOOKUP_EMPTY))
		len = -ENOENT;
	if (unlikely(len == EMBEDDED_NAME_MAX))
		len = getname_long_name(result, filename);
	if (unlikely(len < 0)) {
		free_filename(result);
		return ERR_PTR(len);
	}
	// we are fine, finish setting it up
	...
	return result;


> @@ -246,7 +252,7 @@ struct filename *getname_kernel(const char * filename)
>  	struct filename *result;
>  	int len = strlen(filename) + 1;
>  
> -	result = __getname();
> +	result = alloc_filename();
>  	if (unlikely(!result))
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -258,13 +264,13 @@ struct filename *getname_kernel(const char * filename)
>  
>  		tmp = kmalloc(size, GFP_KERNEL);
>  		if (unlikely(!tmp)) {
> -			__putname(result);
> +			free_filename(result);
>  			return ERR_PTR(-ENOMEM);
>  		}
>  		tmp->name = (char *)result;
>  		result = tmp;

That's wrong - putname() will choke on that (free_filename() on result of
kmalloc()).  Something like
        if (len <= EMBEDDED_NAME_MAX) {
		result->name = (char *)result->iname;
		memcpy(result->name, filename, len);
	} else if (len <= PATH_MAX) {
		result->name = kmemdup(filename, len);
		if (unlikely(!result->name))
			len = -ENOMEM;
	} else {
		len = -ENAMETOOLONG;
	}
	if (unlikely(len < 0) {
		free_filename(result);
		return ERR_PTR(len);
	}
	// finish setting up
	...
	return result;
perhaps?

And if we are going for that kind of changes, I would rather take
that stuff to fs/filename.c, TBH...

