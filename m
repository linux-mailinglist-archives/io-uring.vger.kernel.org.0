Return-Path: <io-uring+bounces-845-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F40874071
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 20:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DF56282D28
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 19:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051FD13F445;
	Wed,  6 Mar 2024 19:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Whooe1W+"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6395C487AE
	for <io-uring@vger.kernel.org>; Wed,  6 Mar 2024 19:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709753654; cv=none; b=rsCP1CF8A2RIRu1Ka9mChBb0W3V6PiHh7JF/HOujxRQjxHp1/rxogNv5qhHBuByrrZWnyBu/RGrcOyhMpMePMGJEgJ48vwYb+CrWxTech7noJ1TnVL2IHs86AKYk7ee2CVj5gThHYQb665ii3J0r7AQoBJOQEXMvk2O3kxBNxHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709753654; c=relaxed/simple;
	bh=SxfVJURIzirgXEki2Q1gUtvHaP3zQ5tvvv5gZnyQEG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cLkv6SUgOklrqx3L0TJEr1k1urmxSPF8UlEuQM3djQ9qPAsmjNcszXiN2HXD7C1+lCFSpR5xpPlTBItXZ+Qt7G+8T2emWegq1omgBpxysjR9d3JYfFaLe3idjsALW4Ubs7vLp6w/faNqghX06B+Ay0PEsIBV6xQlPvSLfTnqDB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Whooe1W+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709753652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VbAJeOilxQrVj/80d5nm/++aGvn6LYNYkNZHnrvuyCM=;
	b=Whooe1W+iO0Ulxw+YIVYJcJ4XfXUF+Jez+8JXk49PgAK87udfeOvfU86SW95+Dl7yygFgH
	YGGMPUudiT9vCVBlR0lkNcgAzciYMbgx00HAiCPdoLgeOHzrCGiaGnfaLJG83Spv8QcB/7
	ueIQK3aFJ+UjBk3bajOEH71xh2FBjqg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-jrnCaxYjNtSw5XXxO3qicw-1; Wed, 06 Mar 2024 14:34:10 -0500
X-MC-Unique: jrnCaxYjNtSw5XXxO3qicw-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1dcb30afc63so983835ad.1
        for <io-uring@vger.kernel.org>; Wed, 06 Mar 2024 11:34:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709753650; x=1710358450;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbAJeOilxQrVj/80d5nm/++aGvn6LYNYkNZHnrvuyCM=;
        b=j+H2nlyKsvzPdqk6W3lGVNLIa3g2Xwg0gkmqOFowVhl5pXC/KTwkUG/2ZQu4evHoGl
         y2xWPt8mIWjgUaB6bH55JySDtW23yr+mQGOxTK/hWPFlM8y0jfzfFyEQYIebt1Ol+g4E
         y0KuMSSOeTX7GjXPFpNCWuqZ2RBfV/JdnmeXIxriBkCks1vlqMg/dem4D6gBG0i8lbAi
         dBqrP3II9cA3Ef23O4T3d6rMBh6smI6e7p7z6v79I+MbzJy2CcEipRoKboq8fAhFugBP
         lQirOaXyJ50nTd73Am69pga0gDGyeOpZxi/QiWxAiCM23aO+SFTcxvABGe3Sh1LBapts
         4+hg==
X-Forwarded-Encrypted: i=1; AJvYcCXgAx4/W7W9cl98GmcrhUBxSy5ICFHyEalPXYdkuX77MtVmkJu9Tk3FdWC3xZb0eM+IW9WWVnBIGoWDQnljujnRSVPHDIYvHyk=
X-Gm-Message-State: AOJu0YxQ7obhUVWL9OlkeVBGk4upML2C9wEbCT+YysXcGn7h8W/BL8J+
	lU7Xjzgh7fZ/XAA9fwbU75Dwl7W3S+a3JQ/lpQdCbcEHVX5+OI020qJMaXE5xW2guT3PAOTHFAQ
	TG1XQ7D92Ey9inJIGDF4IQE0DC8oa59tzOA47xvB0Q8gGaQJ9Wf0IpQsL
X-Received: by 2002:a17:902:8bc9:b0:1db:f952:eebf with SMTP id r9-20020a1709028bc900b001dbf952eebfmr5673841plo.44.1709753649602;
        Wed, 06 Mar 2024 11:34:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWUyGcsbKzjZYh7Y/HcUnkwnNTWxR58rpCHLc8BJPLSI18GJCeamj6Oyk/s1kDQGkFvdS9bA==
X-Received: by 2002:a17:902:8bc9:b0:1db:f952:eebf with SMTP id r9-20020a1709028bc900b001dbf952eebfmr5673802plo.44.1709753648885;
        Wed, 06 Mar 2024 11:34:08 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id kw14-20020a170902f90e00b001db70183611sm12984720plb.270.2024.03.06.11.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 11:34:08 -0800 (PST)
Date: Thu, 7 Mar 2024 03:34:04 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/3] fsstress: check io_uring_queue_init errno properly
Message-ID: <20240306193404.oc34ks4p5ez37s57@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240306091935.4090399-1-zlang@kernel.org>
 <20240306091935.4090399-2-zlang@kernel.org>
 <20240306155357.GA6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306155357.GA6188@frogsfrogsfrogs>

On Wed, Mar 06, 2024 at 07:53:57AM -0800, Darrick J. Wong wrote:
> On Wed, Mar 06, 2024 at 05:19:33PM +0800, Zorro Lang wrote:
> > As the manual of io_uring_queue_init says "io_uring_queue_init(3)
> > returns 0 on success and -errno on failure". We should check if the
> > return value is -ENOSYS, not the errno.
> 
> /me checks liburing source code and sees that the library returns a
> negative error code without touching errno (the semi global error code
> variable) at all.  That's an unfortunate quirk of the manpage, but this
> code here is correct...

Yeah, that confuse me too, especially some io_uring functions set errno,
some return -errno ...

> 
> > Fixes: d15b1721f284 ("ltp/fsstress: don't fail on io_uring ENOSYS")
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> >  ltp/fsstress.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index 63c75767..482395c4 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -763,8 +763,8 @@ int main(int argc, char **argv)
> >  #ifdef URING
> >  			have_io_uring = true;
> >  			/* If ENOSYS, just ignore uring, other errors are fatal. */
> > -			if (io_uring_queue_init(URING_ENTRIES, &ring, 0)) {
> > -				if (errno == ENOSYS) {
> > +			if ((c = io_uring_queue_init(URING_ENTRIES, &ring, 0)) != 0) {
> > +				if (c == -ENOSYS) {
> >  					have_io_uring = false;
> >  				} else {
> >  					fprintf(stderr, "io_uring_queue_init failed\n");
> 
> But why not:
> 
> 			c = io_uring_queue_init(...);
> 			switch (c) {
> 			case 0:
> 				have_io_uring = true;
> 				break;
> 			case -ENOSYS:
> 				have_io_uring = false;
> 				break;
> 			default:
> 				fprintf(stderr, "io_uring_queue_init failed\n");
> 				break;
> 			}
> 
> Especially since you add another case in the next patch?

Sure, that looks more clearly, I'll change this part. Thanks!

> 
> I'll leave the style nits up to you though:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> 
> --D
> 
> > -- 
> > 2.43.0
> > 
> > 
> 


