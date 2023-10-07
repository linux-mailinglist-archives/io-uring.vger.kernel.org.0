Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1247BC433
	for <lists+io-uring@lfdr.de>; Sat,  7 Oct 2023 04:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbjJGCdB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Oct 2023 22:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbjJGCcx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Oct 2023 22:32:53 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0847DC5
        for <io-uring@vger.kernel.org>; Fri,  6 Oct 2023 19:32:51 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6927528c01dso449739b3a.0
        for <io-uring@vger.kernel.org>; Fri, 06 Oct 2023 19:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696645970; x=1697250770; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aE++ezKdN8720LEY7IVJ33vhFnTrqC0qzrEhyMq8nsc=;
        b=wRG/NNYschSu4Ps9+zTjxeb9fHnBi7SneTWGkY4c/571j0QDN/mg7LhJrN6KzjIvza
         eeSDT61CRnPcn+oJiScfbjFPa04fkaC796VlOr5pcdCM5wEKjJa+cOBqDK2L+4TneTv0
         fU6x4kUfFUuTro2n5YgQgIf6EH5NHPCyRtLpTxbJn5jOpJ3IFZ3PoYahn2pPCtDGaona
         pqvaSPr/K9cm9lN07GSaQaMgm2TIypfr8fqDWCMAh5Wb6Ak+Dfy1yNees1gNSyvJni4B
         E1n6SifAedvukbTQRvvRSgXZDSHNTNzIiPqu56yxyYC2NjmjwVB4nUUafPdB9XQBKmLD
         KCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696645970; x=1697250770;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aE++ezKdN8720LEY7IVJ33vhFnTrqC0qzrEhyMq8nsc=;
        b=WGN08WzJHEuBxkZJIUmUnGeUKAICMtGht2OgCMq6CkzadbckqoBBM9iJl1VMUSmS4B
         y5CsYKjkvdjktJTTxOMVfCYAtOgkKleo6itzzfmVFIda9gFGNsFv4a4ZLKTTm+pxLMna
         rBrXaGZhArBmMAJmmWILY443KQ1fbUkzgGkCM/BqGrSw+m8aSeDSB6U6b+5jzkYYCXhg
         qiW4Yk3bJP8YfPGzZcqD0qtBft7Qp6/ZTkWKme8+AKsWoghR/Hk0etaI3q1ArjDPt3YX
         7+sPv9l/0sqa2RiAiW5uTEemW7F7VJ+GjPCCQw8HC2C92677eu67IULu2TW2PO19ln8Z
         ZMvA==
X-Gm-Message-State: AOJu0Yy6xX/R/0Agpc9i2fky/JJWyUeK9b/tkOH0ORDL8cUpDxdJypZO
        G6q9mdb36xth/9ln8yo+bE90ZQ==
X-Google-Smtp-Source: AGHT+IGR8X6ptX3+nEjZ6JSuts+D90XG+BG2spzZdlVNr424PE/dh6kUmay9cpeyTJ2NfkUy7ChUVQ==
X-Received: by 2002:a05:6a00:1d94:b0:690:d314:38d with SMTP id z20-20020a056a001d9400b00690d314038dmr10732845pfw.1.1696645970427;
        Fri, 06 Oct 2023 19:32:50 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id c24-20020a637258000000b0055c178a8df1sm417065pgn.94.2023.10.06.19.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Oct 2023 19:32:49 -0700 (PDT)
Message-ID: <ab758860-e51e-409c-8353-6205fbe515dc@kernel.dk>
Date:   Fri, 6 Oct 2023 20:32:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: audit: io_uring openat triggers audit reference count underflow
 in worker thread
Content-Language: en-US
To:     Dan Clash <Dan.Clash@microsoft.com>,
        "audit@vger.kernel.org" <audit@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "paul@paul-moore.com" <paul@paul-moore.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/23 2:09 PM, Dan Clash wrote:
> diff --git a/fs/namei.c b/fs/namei.c
> index 2a8baa6ce3e8..4f7ac131c9d1 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -187,7 +187,7 @@ getname_flags(const char __user *filename, int flags, int *empty)
>  		}
>  	}
> 
> -	result->refcnt = 1;
> +	refcount_set(&result->refcnt, 1);
>  	/* The empty path is special. */
>  	if (unlikely(!len)) {
>  		if (empty)
> @@ -248,7 +248,7 @@ getname_kernel(const char * filename)
>  	memcpy((char *)result->name, filename, len);
>  	result->uptr = NULL;
>  	result->aname = NULL;
> -	result->refcnt = 1;
> +	refcount_set(&result->refcnt, 1);
>  	audit_getname(result);
> 
>  	return result;
> @@ -259,9 +259,10 @@ void putname(struct filename *name)
>  	if (IS_ERR(name))
>  		return;
> 
> -	BUG_ON(name->refcnt <= 0);
> +	BUG_ON(refcount_read(&name->refcnt) == 0);
> +	BUG_ON(refcount_read(&name->refcnt) == REFCOUNT_SATURATED);
> 
> -	if (--name->refcnt > 0)
> +	if (!refcount_dec_and_test(&name->refcnt))
>  		return;
> 
>  	if (name->name != name->iname) {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index d0a54e9aac7a..8217e07726d4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2719,7 +2719,7 @@ struct audit_names;
>  struct filename {
>  	const char		*name;	/* pointer to actual string */
>  	const __user char	*uptr;	/* original userland pointer */
> -	int			refcnt;
> +	refcount_t		refcnt;
>  	struct audit_names	*aname;
>  	const char		iname[];
>  };
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 37cded22497e..232e0be9f6d9 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2188,7 +2188,7 @@ __audit_reusename(const __user char *uptr)
>  		if (!n->name)
>  			continue;
>  		if (n->name->uptr == uptr) {
> -			n->name->refcnt++;
> +			refcount_inc(&n->name->refcnt);
>  			return n->name;
>  		}
>  	}
> @@ -2217,7 +2217,7 @@ void __audit_getname(struct filename *name)
>  	n->name = name;
>  	n->name_len = AUDIT_NAME_FULL;
>  	name->aname = n;
> -	name->refcnt++;
> +	refcount_inc(&name->refcnt);
>  }
> 
>  static inline int audit_copy_fcaps(struct audit_names *name,
> @@ -2349,7 +2349,7 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
>  		return;
>  	if (name) {
>  		n->name = name;
> -		name->refcnt++;
> +		refcount_inc(&name->refcnt);
>  	}
> 
>  out:
> @@ -2474,7 +2474,7 @@ void __audit_inode_child(struct inode *parent,
>  		if (found_parent) {
>  			found_child->name = found_parent->name;
>  			found_child->name_len = AUDIT_NAME_FULL;
> -			found_child->name->refcnt++;
> +			refcount_inc(&found_child->name->refcnt);
>  		}
>  	}

I'm not fully aware of what audit is doing with struct filename outside
of needing it for the audit log. Rather than impose the atomic
references for everyone, would it be doable to simply dupe the struct
instead of grabbing the (non-atomic) reference to the existing one?

If not, since there's no over/underflow handling right now, it'd
certainly be cheaper to use an atomic_t here rather than a full
refcount.

-- 
Jens Axboe

