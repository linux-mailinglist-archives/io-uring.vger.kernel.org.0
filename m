Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CB34BD2D2
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 01:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242802AbiBUAT0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Feb 2022 19:19:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237932AbiBUATZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Feb 2022 19:19:25 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ED223BF3;
        Sun, 20 Feb 2022 16:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645402743; x=1676938743;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eqwvLvvhwbM/z4ytWovK0S2D+/RtjbpDYDmRlzEiuX8=;
  b=c5ItyiWpbpztYIHunPb+NV3IdPOnXRi/ipwE7fRXxaYb9I5n47XTrW+5
   xDKKImzrinLY9DqMgf6MZZKGAJ+XjUsiupoq9szZZP3krweF6LfrCqOux
   XFCQn9Tch7N9X7LeAdqn3ovYtyyogG5GCB+t3Qzu4zFvMN1tciXzsbWf1
   6rE9YI0gQRFWQMADPNcA9KGKIy4GxoO7FT/bPyxYkZ9WZAxpjW0i2rr9V
   RfmiIXoriNiKJK/enGHqhaU9Pu4j8xMZm6UEdKeG/AUcpEmUlqsy3t5FH
   4vt4D3a/df9S0SdNHF87lt69tgobvFRDqRtsi9hBIpFLMgebUjU2ZxbD3
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="251594439"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="251594439"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 16:19:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="638370649"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 20 Feb 2022 16:19:00 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLwPr-00014O-IC; Mon, 21 Feb 2022 00:18:59 +0000
Date:   Mon, 21 Feb 2022 08:18:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com
Cc:     kbuild-all@lists.01.org, shr@fb.com
Subject: Re: [PATCH v2 06/13] fs: Add gfp_t parameter to create_page_buffers()
Message-ID: <202202210828.SR411CM4-lkp@intel.com>
References: <20220218195739.585044-7-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218195739.585044-7-shr@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 9195e5e0adbb8a9a5ee9ef0f9dedf6340d827405]

url:    https://github.com/0day-ci/linux/commits/Stefan-Roesch/Support-sync-buffered-writes-for-io-uring/20220220-172629
base:   9195e5e0adbb8a9a5ee9ef0f9dedf6340d827405
config: sparc64-randconfig-s031-20220220 (https://download.01.org/0day-ci/archive/20220221/202202210828.SR411CM4-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/e98a7c2a17960f81efc5968cbc386af7c088a8ed
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Stefan-Roesch/Support-sync-buffered-writes-for-io-uring/20220220-172629
        git checkout e98a7c2a17960f81efc5968cbc386af7c088a8ed
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> fs/buffer.c:2010:60: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected restricted gfp_t [usertype] flags @@     got unsigned int flags @@
   fs/buffer.c:2010:60: sparse:     expected restricted gfp_t [usertype] flags
   fs/buffer.c:2010:60: sparse:     got unsigned int flags
>> fs/buffer.c:2147:87: sparse: sparse: incorrect type in argument 6 (different base types) @@     expected unsigned int flags @@     got restricted gfp_t [assigned] [usertype] gfp @@
   fs/buffer.c:2147:87: sparse:     expected unsigned int flags
   fs/buffer.c:2147:87: sparse:     got restricted gfp_t [assigned] [usertype] gfp

vim +2010 fs/buffer.c

  1991	
  1992	int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned len,
  1993				get_block_t *get_block, const struct iomap *iomap,
  1994				unsigned int flags)
  1995	{
  1996		unsigned from = pos & (PAGE_SIZE - 1);
  1997		unsigned to = from + len;
  1998		struct inode *inode = folio->mapping->host;
  1999		unsigned block_start, block_end;
  2000		sector_t block;
  2001		int err = 0;
  2002		unsigned blocksize, bbits;
  2003		struct buffer_head *bh, *head, *wait[2], **wait_bh=wait;
  2004	
  2005		BUG_ON(!folio_test_locked(folio));
  2006		BUG_ON(from > PAGE_SIZE);
  2007		BUG_ON(to > PAGE_SIZE);
  2008		BUG_ON(from > to);
  2009	
> 2010		head = create_page_buffers(&folio->page, inode, 0, flags);
  2011		blocksize = head->b_size;
  2012		bbits = block_size_bits(blocksize);
  2013	
  2014		block = (sector_t)folio->index << (PAGE_SHIFT - bbits);
  2015	
  2016		for(bh = head, block_start = 0; bh != head || !block_start;
  2017		    block++, block_start=block_end, bh = bh->b_this_page) {
  2018			block_end = block_start + blocksize;
  2019			if (block_end <= from || block_start >= to) {
  2020				if (folio_test_uptodate(folio)) {
  2021					if (!buffer_uptodate(bh))
  2022						set_buffer_uptodate(bh);
  2023				}
  2024				continue;
  2025			}
  2026			if (buffer_new(bh))
  2027				clear_buffer_new(bh);
  2028			if (!buffer_mapped(bh)) {
  2029				WARN_ON(bh->b_size != blocksize);
  2030				if (get_block) {
  2031					err = get_block(inode, block, bh, 1);
  2032					if (err)
  2033						break;
  2034				} else {
  2035					iomap_to_bh(inode, block, bh, iomap);
  2036				}
  2037	
  2038				if (buffer_new(bh)) {
  2039					clean_bdev_bh_alias(bh);
  2040					if (folio_test_uptodate(folio)) {
  2041						clear_buffer_new(bh);
  2042						set_buffer_uptodate(bh);
  2043						mark_buffer_dirty(bh);
  2044						continue;
  2045					}
  2046					if (block_end > to || block_start < from)
  2047						folio_zero_segments(folio,
  2048							to, block_end,
  2049							block_start, from);
  2050					continue;
  2051				}
  2052			}
  2053			if (folio_test_uptodate(folio)) {
  2054				if (!buffer_uptodate(bh))
  2055					set_buffer_uptodate(bh);
  2056				continue; 
  2057			}
  2058			if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
  2059			    !buffer_unwritten(bh) &&
  2060			     (block_start < from || block_end > to)) {
  2061				ll_rw_block(REQ_OP_READ, 0, 1, &bh);
  2062				*wait_bh++=bh;
  2063			}
  2064		}
  2065		/*
  2066		 * If we issued read requests - let them complete.
  2067		 */
  2068		while(wait_bh > wait) {
  2069			wait_on_buffer(*--wait_bh);
  2070			if (!buffer_uptodate(*wait_bh))
  2071				err = -EIO;
  2072		}
  2073		if (unlikely(err))
  2074			page_zero_new_buffers(&folio->page, from, to);
  2075		return err;
  2076	}
  2077	
  2078	int __block_write_begin(struct page *page, loff_t pos, unsigned len,
  2079			get_block_t *get_block)
  2080	{
  2081		return __block_write_begin_int(page_folio(page), pos, len, get_block,
  2082					       NULL, 0);
  2083	}
  2084	EXPORT_SYMBOL(__block_write_begin);
  2085	
  2086	static int __block_commit_write(struct inode *inode, struct page *page,
  2087			unsigned from, unsigned to)
  2088	{
  2089		unsigned block_start, block_end;
  2090		int partial = 0;
  2091		unsigned blocksize;
  2092		struct buffer_head *bh, *head;
  2093	
  2094		bh = head = page_buffers(page);
  2095		blocksize = bh->b_size;
  2096	
  2097		block_start = 0;
  2098		do {
  2099			block_end = block_start + blocksize;
  2100			if (block_end <= from || block_start >= to) {
  2101				if (!buffer_uptodate(bh))
  2102					partial = 1;
  2103			} else {
  2104				set_buffer_uptodate(bh);
  2105				mark_buffer_dirty(bh);
  2106			}
  2107			if (buffer_new(bh))
  2108				clear_buffer_new(bh);
  2109	
  2110			block_start = block_end;
  2111			bh = bh->b_this_page;
  2112		} while (bh != head);
  2113	
  2114		/*
  2115		 * If this is a partial write which happened to make all buffers
  2116		 * uptodate then we can optimize away a bogus readpage() for
  2117		 * the next read(). Here we 'discover' whether the page went
  2118		 * uptodate as a result of this (potentially partial) write.
  2119		 */
  2120		if (!partial)
  2121			SetPageUptodate(page);
  2122		return 0;
  2123	}
  2124	
  2125	/*
  2126	 * block_write_begin takes care of the basic task of block allocation and
  2127	 * bringing partial write blocks uptodate first.
  2128	 *
  2129	 * The filesystem needs to handle block truncation upon failure.
  2130	 */
  2131	int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
  2132			unsigned flags, struct page **pagep, get_block_t *get_block)
  2133	{
  2134		pgoff_t index = pos >> PAGE_SHIFT;
  2135		struct page *page;
  2136		int status;
  2137		gfp_t gfp = 0;
  2138		bool no_wait = (flags & AOP_FLAG_NOWAIT);
  2139	
  2140		if (no_wait)
  2141			gfp = GFP_ATOMIC | __GFP_NOWARN;
  2142	
  2143		page = grab_cache_page_write_begin(mapping, index, flags);
  2144		if (!page)
  2145			return -ENOMEM;
  2146	
> 2147		status = __block_write_begin_int(page_folio(page), pos, len, get_block, NULL, gfp);
  2148		if (unlikely(status)) {
  2149			unlock_page(page);
  2150			put_page(page);
  2151			page = NULL;
  2152		}
  2153	
  2154		*pagep = page;
  2155		return status;
  2156	}
  2157	EXPORT_SYMBOL(block_write_begin);
  2158	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
