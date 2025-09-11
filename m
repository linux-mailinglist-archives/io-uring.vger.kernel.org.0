Return-Path: <io-uring+bounces-9753-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 012ABB537AA
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 17:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47FD716A2C1
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 15:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC48D35082E;
	Thu, 11 Sep 2025 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQkva+HA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E6334F48A;
	Thu, 11 Sep 2025 15:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757604399; cv=none; b=aOT/DTr3Se/mYGdkfe1jtFbNL1jNra9OJE47y055SrddpHJh6LyZfaYUS8z0vDSJjJ5LSVR2NixY+MeuiLBoR8d+SEpvxx6Bkq4w5IkN390s1i7oPeTlSfRljWDvP9dXJVcGdgf4CjJL/keIm03SYGvzoCtA3eCDzgcDgE6JrfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757604399; c=relaxed/simple;
	bh=KY6HcsStRQhhbGANFBSUJno+wq9dPNnvokKYnUa+A9k=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=uWrP1lWfNPaRsmteSZG8RhvhvkhLsLnu4f7FShYditFHwGxrawcNkdduzf0L7awGFFvRTg9+UCpqB25hynPL9+J4TDnfstDnfPrxWggA/J6gE/ST5EbVqw9/Ha9dRbRYBZVnBK4J0jJecdeXO1lfxl4gqMm5d0iLrr2HimS2cW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XQkva+HA; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32b8919e7c7so982849a91.2;
        Thu, 11 Sep 2025 08:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757604397; x=1758209197; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvyycfYJU53mdK60B6k1xwCgWrdT1y57HpHTcDrbUso=;
        b=XQkva+HA1LF0xvCBEyJg1bvRIoa1rVNvIkfLOjBEDoK247pAGHPGuX2W7RxUUt6NC0
         xv0HWPShOvMrmxQLE3wVeUBRs3CP3yFEV2Yi6yHwoZxCkCgk3o+RnDm/tsSEUnkdBpyd
         j7N7/fhzpGulESDf2zFU4BMrLJuyyP7co2Ly7rjhyDMwf461RjQ7z9rOyQidgVT/64x/
         wQFIN+93A7nkBI3DOpwBaaBf9viSYyL7Odj0iQVAow1zlLK/RKuR/SIEE3najq+zlD6c
         SdvcsuUyhUjCwMvWy/jGFA9vyQk7k0XLg2b8q/yvHgF9ChgD5vieWJFi9xVvBV+19AOd
         /Kqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757604397; x=1758209197;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DvyycfYJU53mdK60B6k1xwCgWrdT1y57HpHTcDrbUso=;
        b=JY4eZnwNQWlCLoxzUcPR0ls2E56HNf5x9AajHE38uZdK7RvHVWAJEL8IUw/9WWSvJe
         FbxzknBEdp0lxJ1FDPAKzOMieADu9HX3wcb/wSXZW5g2mTeS5hcpZKZXamydc0k71fvs
         ylUQ1IkNFkyilguFESLOWftUeRewimkv/3akmbJBCtE6c7/ijX9hBFdPCWLxTdSWkiC1
         e8W9+LIoTCyxzXMa8Ggex3cY7K4Pj/7SIFuXaq4McRCdynZ2l1q5ZGDatJBIOM3RouJ4
         dMWzx4TjBMsb7HYmhTxNPjGRmtf4s6BgGt4ImLezULbxmJPzIFtiMyUnt6YzrtHOgwO5
         FbHg==
X-Forwarded-Encrypted: i=1; AJvYcCVNAusVlKOvFhKbTO6H3wlpepxSh2Kabq5zCUMYy77cQSyz2A9K8saZhX7dmdeTN9IATR+sEM7jIas3ph8J@vger.kernel.org, AJvYcCXeeZzw8iKi6yZ7Hjt62+2+sPkdtCgilifWW5hZIN6JU8CkQrucDt64eT1Dd3nodbL7rrd+YVczNFPa@vger.kernel.org
X-Gm-Message-State: AOJu0YyqlmBZOvkOZ2cABoOwMtF3Fwv7Vj05BoY1kYwOzKlEdKMgvKGI
	0tOJ/MM+JheVeZ+64BE+0n0AZ9goORkY+CleG6G4pbgq2KJ8FWmOy+54
X-Gm-Gg: ASbGncsfF+DeU759iyrvBjp1/S3j1JID++m6Na4SnmE7EOu1tllOUPyLIBa+XGptCJR
	S/7zTuExuJFNCesa3VLpg6DQJHM+GeSfkY1vCDFvpJBPzShJ6uWAONfnh5YfhwllGvl1mduBZ0R
	Rf1bH242wRY1uOjDAqtNIpNBw3lM8khsfN13XhDSkphXsdGgtdohm1DZ7Qh6pJAMQ87I8aUi87+
	qRMBK5TMUfynxPcwD7UlgQI2OMUPkl5iJ6VBz5EQmx0ntei1wRphAIj1e3bzKB7NRW3FcLadyDk
	AWoWp2GKOZm7F5skLlG+4Y468ZQXt8wHOxvALXTlM30PYm5vlLx9Niv0ysodclPrjXq3dT8Ba1G
	p4rCox55DFjgEcCP8xCOGnB4B9UA0EsiyJTTIHw==
X-Google-Smtp-Source: AGHT+IFX4qf+vuIsZoroaVQhIX+FRr0pfUbllt2NZXygvX8JS/t9ugc1wy1T3Hcdr/SKKCkIMFBKtQ==
X-Received: by 2002:a17:90b:3847:b0:329:f22a:cc58 with SMTP id 98e67ed59e1d1-32d43f47341mr27474535a91.12.1757604397197;
        Thu, 11 Sep 2025 08:26:37 -0700 (PDT)
Received: from localhost ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd98245f2sm2552681a91.9.2025.09.11.08.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 08:26:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 11 Sep 2025 09:31:37 -0600
Message-Id: <DCQ2V7HPAAPL.1OIBUT89HV16S@gmail.com>
Cc: <io-uring@vger.kernel.org>, <axboe@kernel.dk>,
 <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
 <brauner@kernel.org>, <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 03/10] fhandle: helper for allocating, reading struct
 file_handle
From: "Thomas Bertschinger" <tahbertschinger@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "Thomas Bertschinger"
 <tahbertschinger@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
 <20250910214927.480316-4-tahbertschinger@gmail.com>
 <CAOQ4uxhkU80A75PVB7bsXs2BGhGqKv0vr8RvLb5TnEiMO__pmw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhkU80A75PVB7bsXs2BGhGqKv0vr8RvLb5TnEiMO__pmw@mail.gmail.com>

On Thu Sep 11, 2025 at 6:15 AM MDT, Amir Goldstein wrote:
> On Wed, Sep 10, 2025 at 11:47=E2=80=AFPM Thomas Bertschinger
> <tahbertschinger@gmail.com> wrote:
>>
>> Pull the code for allocating and copying a struct file_handle from
>> userspace into a helper function get_user_handle() just for this.
>>
>> do_handle_open() is updated to call get_user_handle() prior to calling
>> handle_to_path(), and the latter now takes a kernel pointer as a
>> parameter instead of a __user pointer.
>>
>> This new helper, as well as handle_to_path(), are also exposed in
>> fs/internal.h. In a subsequent commit, io_uring will use these helpers
>> to support open_by_handle_at(2) in io_uring.
>>
>> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
>> ---
>>  fs/fhandle.c  | 64 +++++++++++++++++++++++++++++----------------------
>>  fs/internal.h |  3 +++
>>  2 files changed, 40 insertions(+), 27 deletions(-)
>>
>> diff --git a/fs/fhandle.c b/fs/fhandle.c
>> index 605ad8e7d93d..36e194dd4cb6 100644
>> --- a/fs/fhandle.c
>> +++ b/fs/fhandle.c
>> @@ -330,25 +330,45 @@ static inline int may_decode_fh(struct handle_to_p=
ath_ctx *ctx,
>>         return 0;
>>  }
>>
>> -static int handle_to_path(int mountdirfd, struct file_handle __user *uf=
h,
>> -                  struct path *path, unsigned int o_flags)
>> +struct file_handle *get_user_handle(struct file_handle __user *ufh)
>>  {
>> -       int retval =3D 0;
>>         struct file_handle f_handle;
>> -       struct file_handle *handle __free(kfree) =3D NULL;
>> -       struct handle_to_path_ctx ctx =3D {};
>> -       const struct export_operations *eops;
>> +       struct file_handle *handle;
>>
>>         if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle)))
>> -               return -EFAULT;
>> +               return ERR_PTR(-EFAULT);
>>
>>         if ((f_handle.handle_bytes > MAX_HANDLE_SZ) ||
>>             (f_handle.handle_bytes =3D=3D 0))
>> -               return -EINVAL;
>> +               return ERR_PTR(-EINVAL);
>>
>>         if (f_handle.handle_type < 0 ||
>>             FILEID_USER_FLAGS(f_handle.handle_type) & ~FILEID_VALID_USER=
_FLAGS)
>> -               return -EINVAL;
>> +               return ERR_PTR(-EINVAL);
>> +
>> +       handle =3D kmalloc(struct_size(handle, f_handle, f_handle.handle=
_bytes),
>> +                        GFP_KERNEL);
>> +       if (!handle) {
>> +               return ERR_PTR(-ENOMEM);
>> +       }
>> +
>> +       /* copy the full handle */
>> +       *handle =3D f_handle;
>> +       if (copy_from_user(&handle->f_handle,
>> +                          &ufh->f_handle,
>> +                          f_handle.handle_bytes)) {
>> +               return ERR_PTR(-EFAULT);
>> +       }
>> +
>> +       return handle;
>> +}
>> +
>> +int handle_to_path(int mountdirfd, struct file_handle *handle,
>> +                  struct path *path, unsigned int o_flags)
>> +{
>> +       int retval =3D 0;
>> +       struct handle_to_path_ctx ctx =3D {};
>> +       const struct export_operations *eops;
>>
>>         retval =3D get_path_anchor(mountdirfd, &ctx.root);
>>         if (retval)
>> @@ -362,31 +382,16 @@ static int handle_to_path(int mountdirfd, struct f=
ile_handle __user *ufh,
>>         if (retval)
>>                 goto out_path;
>>
>> -       handle =3D kmalloc(struct_size(handle, f_handle, f_handle.handle=
_bytes),
>> -                        GFP_KERNEL);
>> -       if (!handle) {
>> -               retval =3D -ENOMEM;
>> -               goto out_path;
>> -       }
>> -       /* copy the full handle */
>> -       *handle =3D f_handle;
>> -       if (copy_from_user(&handle->f_handle,
>> -                          &ufh->f_handle,
>> -                          f_handle.handle_bytes)) {
>> -               retval =3D -EFAULT;
>> -               goto out_path;
>> -       }
>> -
>>         /*
>>          * If handle was encoded with AT_HANDLE_CONNECTABLE, verify that=
 we
>>          * are decoding an fd with connected path, which is accessible f=
rom
>>          * the mount fd path.
>>          */
>> -       if (f_handle.handle_type & FILEID_IS_CONNECTABLE) {
>> +       if (handle->handle_type & FILEID_IS_CONNECTABLE) {
>>                 ctx.fh_flags |=3D EXPORT_FH_CONNECTABLE;
>>                 ctx.flags |=3D HANDLE_CHECK_SUBTREE;
>>         }
>> -       if (f_handle.handle_type & FILEID_IS_DIR)
>> +       if (handle->handle_type & FILEID_IS_DIR)
>>                 ctx.fh_flags |=3D EXPORT_FH_DIR_ONLY;
>>         /* Filesystem code should not be exposed to user flags */
>>         handle->handle_type &=3D ~FILEID_USER_FLAGS_MASK;
>> @@ -400,12 +405,17 @@ static int handle_to_path(int mountdirfd, struct f=
ile_handle __user *ufh,
>>  static long do_handle_open(int mountdirfd, struct file_handle __user *u=
fh,
>>                            int open_flag)
>>  {
>> +       struct file_handle *handle __free(kfree) =3D NULL;
>>         long retval =3D 0;
>>         struct path path __free(path_put) =3D {};
>>         struct file *file;
>>         const struct export_operations *eops;
>>
>> -       retval =3D handle_to_path(mountdirfd, ufh, &path, open_flag);
>> +       handle =3D get_user_handle(ufh);
>> +       if (IS_ERR(handle))
>> +               return PTR_ERR(handle);
>
> I don't think you can use __free(kfree) for something that can be an ERR_=
PTR.
>
> Thanks,
> Amir.

It looks like the error pointer is correctly handled?

in include/linux/slab.h:

DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))

