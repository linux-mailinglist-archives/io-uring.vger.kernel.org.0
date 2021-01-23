Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328453018FC
	for <lists+io-uring@lfdr.de>; Sun, 24 Jan 2021 00:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbhAWXwK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Jan 2021 18:52:10 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:33487 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbhAWXwG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Jan 2021 18:52:06 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id ED7D71410;
        Sat, 23 Jan 2021 18:50:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 23 Jan 2021 18:50:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=c
        PlFxpNv2oNB0vFGCOsPAhamOFNd5t/o49o2BsP4y5M=; b=Eqq2fgHAQLx2WN2Qh
        BUBfOLsXNRsjiD81ckiHWIHXny6MamjqOTveIjbbSXgV9YU7zKkLAcY80uwhNTZd
        GKnedgB0mfJyuJJJpMx3DI2sm5aJnJZ6sLXICAvJzTmed2O6MNzSGZMWq5EpJM+W
        2wvCXHZKJqhffiHEpF1qTKXDP/M+Bs2QAWtKvwpG6n7jlnvHhYp42D7Uc/OMd1sC
        Q3QG5tr2xRRxyMSMCVu7rep2sswKQmFVbYu/4AT2XxlXxkU2OtcMv2kNifNKBL6T
        6nwPhBoL5K+rYRAABfOomu0pPMNanfFPLpuZsvmaHaWL2wDYZMPUdkgM4MiE5b2E
        a68FQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=cPlFxpNv2oNB0vFGCOsPAhamOFNd5t/o49o2BsP4y
        5M=; b=D/bq/D2H4z8EJSVIVnLzqA2MMt67K8MlnTYeKZIRrx8Ixbs6LXWyISkaQ
        PdP/6gNZXt4OP4zZ4RTl3uqcFj9JEaBLdudEwLQK5LVrmHxZMnSej2TEb4Jc3KAe
        bsDkKPO9q/Dpoo5H/+6Z/87t5IEKcjhY0b+i1fQJNiXVwVzZF1r8fOpAluUT4t1w
        w1JB1ba3avpnn9+k7pcjrpmelgFTeOgk88KqtwO7Ci1ReNIZqO16VsHPSBUcJ2t4
        +4osGBbo14K5dKKuCsoQMH+X9S33pjI05IcMZCDZD2FWCYi6nLdxVzm6SkPTxSUa
        F1dTLLvW4fvmCZT8PWmf7TC1yiqjg==
X-ME-Sender: <xms:YLYMYPzeZGReVQfFn6uD-0wxPEnV3BIMz98RTITGL7fuo7He2W_jyw>
    <xme:YLYMYHR1j790K4etFPiW5ltklUPODGADt9oFOczItFPU5gz3d4PJ5yR9D-elovtWN
    ab2S0vlnayw6ebk2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpeejheeivdevffeijeffheegfeejveffteeviedugeegtdehffdvffekudek
    tdehjeenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdr
    uggv
X-ME-Proxy: <xmx:YbYMYJWS60lmxMrR-uZLxSbOJYvYwM51lbh31Y_LnuiMDDv73QASmA>
    <xmx:YbYMYJizPrte_tTV_ltHBaga8ILHAuRYDF3VAL8z2jvKstL52o41jQ>
    <xmx:YbYMYBDMcKs1kUUbyTgPu_vcsx66P6v681Su9_1aoJ-_KX_LiCJNFw>
    <xmx:YbYMYANHqEGQxyYQ3EwFjXuyZjkdQ9Jz-ZaLUA3v862JVcAhWWpLnw>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id D5A101080059;
        Sat, 23 Jan 2021 18:50:56 -0500 (EST)
Date:   Sat, 23 Jan 2021 15:50:55 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Message-ID: <20210123235055.azmz5jm2lwyujygc@alap3.anarazel.de>
References: <20210123114152.GA120281@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210123114152.GA120281@wantstofly.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2021-01-23 13:41:52 +0200, Lennert Buytenhek wrote:
> IORING_OP_GETDENTS64 behaves like getdents64(2) and takes the same
> arguments.

I've wished for this before, this would be awesome.


> One open question is whether IORING_OP_GETDENTS64 should be more like
> pread(2) and allow passing in a starting offset to read from the
> directory from.  (This would require some more surgery in fs/readdir.c.)

That would imo be preferrable from my end - using the fd's position
means that the fd cannot be shared between threads etc.

It's also not clear to me that right now you'd necessarily get correct
results if multiple IORING_OP_GETDENTS64 for the same fd get processed
in different workers.  Looking at iterate_dir(), it looks to me that the
locking around the file position would end up being insufficient on
filesystems that implement iterate_shared?

int iterate_dir(struct file *file, struct dir_context *ctx)
{
	struct inode *inode = file_inode(file);
	bool shared = false;
	int res = -ENOTDIR;
	if (file->f_op->iterate_shared)
		shared = true;
	else if (!file->f_op->iterate)
		goto out;

	res = security_file_permission(file, MAY_READ);
	if (res)
		goto out;

	if (shared)
		res = down_read_killable(&inode->i_rwsem);
	else
		res = down_write_killable(&inode->i_rwsem);
	if (res)
		goto out;

	res = -ENOENT;
	if (!IS_DEADDIR(inode)) {
		ctx->pos = file->f_pos;
		if (shared)
			res = file->f_op->iterate_shared(file, ctx);
		else
			res = file->f_op->iterate(file, ctx);
		file->f_pos = ctx->pos;
		fsnotify_access(file);
		file_accessed(file);
	}
	if (shared)
		inode_unlock_shared(inode);
	else
		inode_unlock(inode);
out:
	return res;
}

As there's only a shared lock, seems like both would end up with the
same ctx->pos and end up updating f_pos to the same offset (assuming the
same count).

Am I missing something?

Greetings,

Andres Freund
