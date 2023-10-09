Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC1C7BE454
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 17:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376775AbjJIPPM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Oct 2023 11:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377784AbjJIPOi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Oct 2023 11:14:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD41D44;
        Mon,  9 Oct 2023 08:14:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9B7CD1F381;
        Mon,  9 Oct 2023 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696864468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLQol6nlWPwTWlJ62M8BQmpCS583VclEcykOVZNn9HE=;
        b=qEUirXlluiMX2wLDqE9aFtf+614pyDW5IBKwHK+QCUvxoir0KHuf7DSyrjgVLPoc+ZF6hv
        fisVaDh/fVtdrkHwnkI/D9hrKnAwaoGVW9H8zmV9S13mmx2V+d3nCc3nrORQgEWW3YzH9c
        zeGrdplae++gBP+S6ohv3Cu3sb2kPW4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696864468;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLQol6nlWPwTWlJ62M8BQmpCS583VclEcykOVZNn9HE=;
        b=sdhFgP8Y1aXrvoJ1Yr2wSi2wpOYI85IfxP55MFg4JIdSnIgiNL0zSdWK1qglFFj+5bbOhl
        zpapeBn+SHHfSHDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 26A9D13905;
        Mon,  9 Oct 2023 15:14:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TWrOBtQYJGX/KAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 09 Oct 2023 15:14:28 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id b29327c4;
        Mon, 9 Oct 2023 15:14:27 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [RFC PATCH] fs: add AT_EMPTY_PATH support to unlinkat()
In-Reply-To: <20231009020623.GB800259@ZenIV> (Al Viro's message of "Mon, 9 Oct
        2023 03:06:23 +0100")
References: <20230929140456.23767-1-lhenriques@suse.de>
        <20231009020623.GB800259@ZenIV>
Date:   Mon, 09 Oct 2023 16:14:27 +0100
Message-ID: <87lecbrfos.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> writes:

> On Fri, Sep 29, 2023 at 03:04:56PM +0100, Luis Henriques wrote:
>
>> -int do_unlinkat(int dfd, struct filename *name)
>> +int do_unlinkat(int dfd, struct filename *name, int flags)
>>  {
>>  	int error;
>> -	struct dentry *dentry;
>> +	struct dentry *dentry, *parent;
>>  	struct path path;
>>  	struct qstr last;
>>  	int type;
>>  	struct inode *inode =3D NULL;
>>  	struct inode *delegated_inode =3D NULL;
>>  	unsigned int lookup_flags =3D 0;
>> -retry:
>> -	error =3D filename_parentat(dfd, name, lookup_flags, &path, &last, &ty=
pe);
>> -	if (error)
>> -		goto exit1;
>> +	bool empty_path =3D (flags & AT_EMPTY_PATH);
>>=20=20
>> -	error =3D -EISDIR;
>> -	if (type !=3D LAST_NORM)
>> -		goto exit2;
>> +retry:
>> +	if (empty_path) {
>> +		error =3D filename_lookup(dfd, name, 0, &path, NULL);
>> +		if (error)
>> +			goto exit1;
>> +		parent =3D path.dentry->d_parent;
>> +		dentry =3D path.dentry;
>> +	} else {
>> +		error =3D filename_parentat(dfd, name, lookup_flags, &path, &last, &t=
ype);
>> +		if (error)
>> +			goto exit1;
>> +		error =3D -EISDIR;
>> +		if (type !=3D LAST_NORM)
>> +			goto exit2;
>> +		parent =3D path.dentry;
>> +	}
>>=20=20
>>  	error =3D mnt_want_write(path.mnt);
>>  	if (error)
>>  		goto exit2;
>>  retry_deleg:
>> -	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
>> -	dentry =3D lookup_one_qstr_excl(&last, path.dentry, lookup_flags);
>> +	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
>> +	if (!empty_path)
>> +		dentry =3D lookup_one_qstr_excl(&last, parent, lookup_flags);
>
> For starters, your 'parent' might have been freed under you, just as you'd
> been trying to lock its inode.  Or it could have become negative just as =
you'd
> been fetching its ->d_inode, while we are at it.
>
> Races aside, you are changing permissions required for removing files.  F=
or
> unlink() you need to be able to get to the parent directory; if it's e.g.
> outside of your namespace, you can't do anything to it.  If file had been
> opened there by somebody who could reach it and passed to you (via SCM_RI=
GHTS,
> for example) you currently can't remove the sucker.  With this change that
> is no longer true.
>
> The same goes for the situation when file is bound into your namespace (or
> chroot jail, for that matter).  path.dentry might very well be equal to
> root of path.mnt; path.dentry->d_parent might be in part of tree that is
> no longer visible *anywhere*.  rmdir() should not be able to do anything
> with it...
>
> IMO it's fundamentally broken; not just implementation, but the concept
> itself.
>
> NAKed-by: Al Viro <viro@zeniv.linux.org.uk>

Thank you for your review, which made me glad I sent out the patch early
as an RFC.  I (think I) understand the issues you pointed out and,
although some of them could be fixed (the races), I guess there's no point
pursuing this any further, since you consider the concept itself to be
broken.  Again, thank you for your time.

Cheers,
--=20
Lu=C3=ADs
