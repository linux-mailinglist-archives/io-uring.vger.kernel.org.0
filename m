Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0C84B408E
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 05:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240126AbiBNEBw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Feb 2022 23:01:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbiBNEBv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Feb 2022 23:01:51 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8BA4EA3D;
        Sun, 13 Feb 2022 20:01:44 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJSYZ-001dix-8Y; Mon, 14 Feb 2022 04:01:43 +0000
Date:   Mon, 14 Feb 2022 04:01:43 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v1 1/2] fs: replace const char* parameter in vfs_statx
 and do_statx with struct filename
Message-ID: <YgnUJ6ivB5wTsaGs@zeniv-ca.linux.org.uk>
References: <20220209190345.2374478-1-shr@fb.com>
 <20220209190345.2374478-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209190345.2374478-2-shr@fb.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 09, 2022 at 11:03:44AM -0800, Stefan Roesch wrote:
> +	int ret;
> +	int statx_flags = flags | AT_NO_AUTOMOUNT;
> +	struct filename *name;
> +
> +	name = getname_flags(filename, getname_statx_lookup_flags(statx_flags), NULL);
> +	ret = vfs_statx(dfd, name, statx_flags, stat, STATX_BASIC_STATS);
> +	if (name)
> +		putname(name);

1) getname and friends return an error as ERR_PTR(-E...), not NULL
2) filename_lookup() et.al. treat ERR_PTR(-E...) as "fail with -E..."
3) putname(ERR_PTR(-E...)) is a no-op.

IOW, that if (name) putname(name); is unidiomatic and misleading.
