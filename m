Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B19F6FF041
	for <lists+io-uring@lfdr.de>; Thu, 11 May 2023 12:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbjEKK4Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 May 2023 06:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237751AbjEKK4X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 May 2023 06:56:23 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A5859C6
        for <io-uring@vger.kernel.org>; Thu, 11 May 2023 03:56:19 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f435658d23so24080325e9.3
        for <io-uring@vger.kernel.org>; Thu, 11 May 2023 03:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683802578; x=1686394578;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8UsFW/OKFLWzrfCHWAMRNvjMDP4f9tp8Nm34IOcM96Q=;
        b=Fna4hgvy4ayNdl2Mw7PgG9YfGLMggJPpJVbidjfaUama/51qz00nOGttQcvAWaDqwB
         u9TL2r8S9+R9piJxfwOCKdDBo4I0rl+Ed5PdQOtkqP6FxMxJU4kbkFqREqyQZff2cUrL
         NV5IEszFMo+s12cAjxzLlIRk2YUAF7UObDdWykNUzVMk//jNKVw1rEvGJapVQy9L6pJE
         IwzUs9NhPh6si5MlYEr+ftyW9jwY5vBqU0aNJ4vRsEEROKpIybncvu/FPLDQ8IYxHp7i
         9kmw03xUvVfIuqGHL9tBm4LEU84SBmrla8GdQ+wyDwvwhRcCZ6GWuP5v0CSlquPlI+Bl
         FP/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683802578; x=1686394578;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8UsFW/OKFLWzrfCHWAMRNvjMDP4f9tp8Nm34IOcM96Q=;
        b=Z6wUghrk9nlCzjOUk5n+JGwST00ZdGX3JLy+oxiWckPkvrJyK6/it5oZHALZ+BdyZW
         XAtJHXqHXGeGxTz84bX10qn2mLnmEUmRmmN/SWO9Wim9m7Seqwb+Fe5rOjRfSpr1Y2Ld
         b3i3eevz+tsuRkycXU+KfPk9GAfLQaECWV0Ve0348rGmXSonL55wQNEiK4QUcRlauETY
         UZlQJuChDwZHozveIGv78EzToUmbeq/D3VPGplUgZnrZ4vLJUDKEWT091VkszENHorsP
         eOniqAIjkjfjNiYba7otOrwYFmQcCsjRWrduZyviPX8CZ/UeVtUKM+SyzLvOJ0zWAmx0
         /Qqw==
X-Gm-Message-State: AC+VfDwZlL9WZmA3sGBk69ZvDlakSB1eGixi5J/AJpp9N5HpOUHE+8SR
        GS6JJMWB2sO3yARoH8sDPHpR3A==
X-Google-Smtp-Source: ACHHUZ5Qb4Owy3olfvWB+XIkZ9U0CNEoY63lEPKXoLzpv/B9Aw7XlwLxfHWcozMz880g73eeikEk7w==
X-Received: by 2002:a05:600c:2047:b0:3f4:2452:9675 with SMTP id p7-20020a05600c204700b003f424529675mr9666596wmg.0.1683802577815;
        Thu, 11 May 2023 03:56:17 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f5-20020adff985000000b002fda1b12a0bsm20319280wrr.2.2023.05.11.03.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 03:56:15 -0700 (PDT)
Date:   Thu, 11 May 2023 13:55:57 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     oe-kbuild@lists.linux.dev,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [PATCH v2 4/6] kernfs: implement readdir FMODE_NOWAIT
Message-ID: <4e88ec58-be22-4b0c-968d-fa9a52764c98@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422-uring-getdents-v2-4-2db1e37dc55e@codewreck.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Dominique,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Dominique-Martinet/fs-split-off-vfs_getdents-function-of-getdents64-syscall/20230510-185542
base:   58390c8ce1bddb6c623f62e7ed36383e7fa5c02f
patch link:    https://lore.kernel.org/r/20230422-uring-getdents-v2-4-2db1e37dc55e%40codewreck.org
patch subject: [PATCH v2 4/6] kernfs: implement readdir FMODE_NOWAIT
config: i386-randconfig-m021 (https://download.01.org/0day-ci/archive/20230511/202305110647.eSnSEulg-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Link: https://lore.kernel.org/r/202305110647.eSnSEulg-lkp@intel.com/

smatch warnings:
fs/kernfs/dir.c:1863 kernfs_fop_readdir() warn: inconsistent returns '&root->kernfs_rwsem'.

vim +1863 fs/kernfs/dir.c

c637b8acbe079e Tejun Heo          2013-12-11  1815  static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1816  {
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1817  	struct dentry *dentry = file->f_path.dentry;
319ba91d352a74 Shaohua Li         2017-07-12  1818  	struct kernfs_node *parent = kernfs_dentry_node(dentry);
324a56e16e44ba Tejun Heo          2013-12-11  1819  	struct kernfs_node *pos = file->private_data;
393c3714081a53 Minchan Kim        2021-11-18  1820  	struct kernfs_root *root;
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1821  	const void *ns = NULL;
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1822  
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1823  	if (!dir_emit_dots(file, ctx))
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1824  		return 0;
393c3714081a53 Minchan Kim        2021-11-18  1825  
393c3714081a53 Minchan Kim        2021-11-18  1826  	root = kernfs_root(parent);
a551138c4b3b9f Dominique Martinet 2023-05-10  1827  	if (ctx->flags & DIR_CONTEXT_F_NOWAIT) {
a551138c4b3b9f Dominique Martinet 2023-05-10  1828  		if (!down_read_trylock(&root->kernfs_rwsem))
a551138c4b3b9f Dominique Martinet 2023-05-10  1829  			return -EAGAIN;
a551138c4b3b9f Dominique Martinet 2023-05-10  1830  	} else {
393c3714081a53 Minchan Kim        2021-11-18  1831  		down_read(&root->kernfs_rwsem);
a551138c4b3b9f Dominique Martinet 2023-05-10  1832  	}
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1833  
324a56e16e44ba Tejun Heo          2013-12-11  1834  	if (kernfs_ns_enabled(parent))
c525aaddc366df Tejun Heo          2013-12-11  1835  		ns = kernfs_info(dentry->d_sb)->ns;
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1836  
c637b8acbe079e Tejun Heo          2013-12-11  1837  	for (pos = kernfs_dir_pos(ns, parent, ctx->pos, pos);
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1838  	     pos;
c637b8acbe079e Tejun Heo          2013-12-11  1839  	     pos = kernfs_dir_next_pos(ns, parent, ctx->pos, pos)) {
adc5e8b58f4886 Tejun Heo          2013-12-11  1840  		const char *name = pos->name;
364595a6851bf6 Jeff Layton        2023-03-30  1841  		unsigned int type = fs_umode_to_dtype(pos->mode);
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1842  		int len = strlen(name);
67c0496e87d193 Tejun Heo          2019-11-04  1843  		ino_t ino = kernfs_ino(pos);
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1844  
adc5e8b58f4886 Tejun Heo          2013-12-11  1845  		ctx->pos = pos->hash;
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1846  		file->private_data = pos;
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1847  		kernfs_get(pos);
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1848  
393c3714081a53 Minchan Kim        2021-11-18  1849  		up_read(&root->kernfs_rwsem);
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1850  		if (!dir_emit(ctx, name, len, ino, type))
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1851  			return 0;
393c3714081a53 Minchan Kim        2021-11-18  1852  		down_read(&root->kernfs_rwsem);
                                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Needs to be deleted.

a551138c4b3b9f Dominique Martinet 2023-05-10  1853  		if (ctx->flags & DIR_CONTEXT_F_NOWAIT) {
a551138c4b3b9f Dominique Martinet 2023-05-10  1854  			if (!down_read_trylock(&root->kernfs_rwsem))
a551138c4b3b9f Dominique Martinet 2023-05-10  1855  				return 0;

It's a bit strange the this doesn't return -EAGAIN;

a551138c4b3b9f Dominique Martinet 2023-05-10  1856  		} else {
a551138c4b3b9f Dominique Martinet 2023-05-10  1857  			down_read(&root->kernfs_rwsem);
a551138c4b3b9f Dominique Martinet 2023-05-10  1858  		}
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1859  	}
393c3714081a53 Minchan Kim        2021-11-18  1860  	up_read(&root->kernfs_rwsem);
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1861  	file->private_data = NULL;
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1862  	ctx->pos = INT_MAX;
fd7b9f7b9776b1 Tejun Heo          2013-11-28 @1863  	return 0;
fd7b9f7b9776b1 Tejun Heo          2013-11-28  1864  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

