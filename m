Return-Path: <io-uring+bounces-10164-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2BDC03381
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 21:50:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 19DD44E3173
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 19:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E24C34D4E0;
	Thu, 23 Oct 2025 19:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZLz2Klo4"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1FF347BC3;
	Thu, 23 Oct 2025 19:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249008; cv=none; b=mXxlX3awp0rEe8YSA+YBmeKPCJy0JuYd8AiOSZD1gBnvCLq/deU5UzblwafFDGxFaXkISHryxaW7+xDwdqiKvILpheMjQdW2W5JbD2ZhPd7nJTawFhWn4zoFh7UdSpPL/aVo615OGrgUhKoEi8jrRLVlDJEYMk4QEfPmSItVAY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249008; c=relaxed/simple;
	bh=Skua1k2e3mB8SWqi2ga5oqhkJAG1HZvPfRJSsVS0qSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9etJFLdcNdjs3LkqxcO6Z+5JmcSXuGvxHKOZicH4QmsmQHgPmIgjUvKutqJW//XUCVFE3y+w6niRkYJA59K40JBCgZMzTVgxdCbPD+MOQetmz+txgpwPkp6c5fDeX2R+4F5YREkgGlUdkoLm8x2ibvWfKpXgBKkULw6EAFmtdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZLz2Klo4; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761249007; x=1792785007;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Skua1k2e3mB8SWqi2ga5oqhkJAG1HZvPfRJSsVS0qSs=;
  b=ZLz2Klo4R4tYYGviKTCdl5RTmMHx4SISJLC2aA5In695g4TTOwqXMQIH
   afapLi8riDpW41ZNGN74d9arE+A9BMmGRmbkz3M4+Y7Zqu9fjjmg1GG9Y
   iArXU5Hqnhbbh8/yqssDViFV+mN0EqT1O3ceQcjZqR1SgsvHVLgXCFrlh
   PHGQ5mm7TeDwcfc31QxqVVZEgMLkX3SvaStdCiNqXq8LSYqFBWwCHSXXa
   GwR/MeX6CxbWZfGaRXPYylv70EH9yb+7k/8AQRcAWOOUyxsHnYCtkfeU+
   w5RzGxAM+ZW6VKWXHZd3NBjPkUnqrnY/o6v+clRjq8elVdkh42JI4AGME
   w==;
X-CSE-ConnectionGUID: fU+zXQlXQi6Kkp1SPCe0bg==
X-CSE-MsgGUID: d+ZktQ+1SNmZ1ekorTf7fQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74870034"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="74870034"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 12:50:04 -0700
X-CSE-ConnectionGUID: 2Rs/IhRhSS2PSn3gAgtgDQ==
X-CSE-MsgGUID: 6Y2P8BYzRYeQpitDQCe9ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="207894922"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 23 Oct 2025 12:50:00 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vC1Jj-000Dp7-15;
	Thu, 23 Oct 2025 19:49:50 +0000
Date: Fri, 24 Oct 2025 03:49:09 +0800
From: kernel test robot <lkp@intel.com>
To: Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <miklos@szeredi.hu>,
	Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chris Mason <chris.mason@fusionio.com>,
	David Sterba <dsterba@suse.com>
Cc: oe-kbuild-all@lists.linux.dev, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH 3/3] io_uring/uring_cmd: avoid double indirect call in
 task work dispatch
Message-ID: <202510240319.bLypyxx1-lkp@intel.com>
References: <20251022231326.2527838-4-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022231326.2527838-4-csander@purestorage.com>

Hi Caleb,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on kdave/for-next linus/master v6.18-rc2]
[cannot apply to mszeredi-fuse/for-next linux-nvme/for-next next-20251023]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Caleb-Sander-Mateos/io_uring-expose-io_should_terminate_tw/20251023-071617
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20251022231326.2527838-4-csander%40purestorage.com
patch subject: [PATCH 3/3] io_uring/uring_cmd: avoid double indirect call in task work dispatch
config: arm-randconfig-002-20251024 (https://download.01.org/0day-ci/archive/20251024/202510240319.bLypyxx1-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251024/202510240319.bLypyxx1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510240319.bLypyxx1-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> block/ioctl.c:781:8: error: return type defaults to 'int' [-Wimplicit-int]
     781 | static DEFINE_IO_URING_CMD_TASK_WORK(blk_cmd_complete)
         |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> block/ioctl.c:781:8: error: function declaration isn't a prototype [-Werror=strict-prototypes]
   block/ioctl.c: In function 'DEFINE_IO_URING_CMD_TASK_WORK':
>> block/ioctl.c:784:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     784 | {
         | ^
   block/ioctl.c:798:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     798 | {
         | ^
   block/ioctl.c:853:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     853 | {
         | ^
>> block/ioctl.c:781:8: error: type of 'blk_cmd_complete' defaults to 'int' [-Wimplicit-int]
     781 | static DEFINE_IO_URING_CMD_TASK_WORK(blk_cmd_complete)
         |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> block/ioctl.c:876: error: expected '{' at end of input
   block/ioctl.c: At top level:
>> block/ioctl.c:781:8: warning: 'DEFINE_IO_URING_CMD_TASK_WORK' defined but not used [-Wunused-function]
     781 | static DEFINE_IO_URING_CMD_TASK_WORK(blk_cmd_complete)
         |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> block/ioctl.c:772:13: warning: 'blk_cmd_complete' defined but not used [-Wunused-function]
     772 | static void blk_cmd_complete(struct io_uring_cmd *cmd, unsigned int issue_flags)
         |             ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
>> drivers/nvme/host/ioctl.c:410:8: error: return type defaults to 'int' [-Wimplicit-int]
     410 | static DEFINE_IO_URING_CMD_TASK_WORK(nvme_uring_task_cb)
         |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/nvme/host/ioctl.c:410:8: error: function declaration isn't a prototype [-Werror=strict-prototypes]
   drivers/nvme/host/ioctl.c: In function 'DEFINE_IO_URING_CMD_TASK_WORK':
>> drivers/nvme/host/ioctl.c:414:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     414 | {
         | ^
   drivers/nvme/host/ioctl.c:441:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     441 | {
         | ^
   drivers/nvme/host/ioctl.c:534:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     534 | {
         | ^
   drivers/nvme/host/ioctl.c:544:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     544 | {
         | ^
   drivers/nvme/host/ioctl.c:575:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     575 | {
         | ^
   drivers/nvme/host/ioctl.c:605:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     605 | {
         | ^
   drivers/nvme/host/ioctl.c:620:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     620 | {
         | ^
   drivers/nvme/host/ioctl.c:632:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     632 | {
         | ^
   drivers/nvme/host/ioctl.c:643:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     643 | {
         | ^
   drivers/nvme/host/ioctl.c:666:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     666 | {
         | ^
   drivers/nvme/host/ioctl.c:676:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     676 | {
         | ^
   drivers/nvme/host/ioctl.c:777:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     777 | {
         | ^
   drivers/nvme/host/ioctl.c:805:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     805 | {
         | ^
   drivers/nvme/host/ioctl.c:842:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     842 | {
         | ^
>> drivers/nvme/host/ioctl.c:410:8: error: type of 'nvme_uring_task_cb' defaults to 'int' [-Wimplicit-int]
     410 | static DEFINE_IO_URING_CMD_TASK_WORK(nvme_uring_task_cb)
         |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/nvme/host/ioctl.c:872: error: expected '{' at end of input
   drivers/nvme/host/ioctl.c: At top level:
>> drivers/nvme/host/ioctl.c:410:8: warning: 'DEFINE_IO_URING_CMD_TASK_WORK' defined but not used [-Wunused-function]
     410 | static DEFINE_IO_URING_CMD_TASK_WORK(nvme_uring_task_cb)
         |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/nvme/host/ioctl.c:401:13: warning: 'nvme_uring_task_cb' defined but not used [-Wunused-function]
     401 | static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd,
         |             ^~~~~~~~~~~~~~~~~~
>> drivers/nvme/host/ioctl.c:329:12: warning: 'nvme_user_cmd64' defined but not used [-Wunused-function]
     329 | static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
         |            ^~~~~~~~~~~~~~~
>> drivers/nvme/host/ioctl.c:281:12: warning: 'nvme_user_cmd' defined but not used [-Wunused-function]
     281 | static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
         |            ^~~~~~~~~~~~~
>> drivers/nvme/host/ioctl.c:206:12: warning: 'nvme_submit_io' defined but not used [-Wunused-function]
     206 | static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
         |            ^~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/int +781 block/ioctl.c

   771	
 > 772	static void blk_cmd_complete(struct io_uring_cmd *cmd, unsigned int issue_flags)
   773	{
   774		struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
   775	
   776		if (bic->res == -EAGAIN && bic->nowait)
   777			io_uring_cmd_issue_blocking(cmd);
   778		else
   779			io_uring_cmd_done(cmd, bic->res, issue_flags);
   780	}
 > 781	static DEFINE_IO_URING_CMD_TASK_WORK(blk_cmd_complete)
   782	
   783	static void bio_cmd_bio_end_io(struct bio *bio)
 > 784	{
   785		struct io_uring_cmd *cmd = bio->bi_private;
   786		struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
   787	
   788		if (unlikely(bio->bi_status) && !bic->res)
   789			bic->res = blk_status_to_errno(bio->bi_status);
   790	
   791		io_uring_cmd_do_in_task_lazy(cmd, blk_cmd_complete);
   792		bio_put(bio);
   793	}
   794	
   795	static int blkdev_cmd_discard(struct io_uring_cmd *cmd,
   796				      struct block_device *bdev,
   797				      uint64_t start, uint64_t len, bool nowait)
 > 798	{
   799		struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
   800		gfp_t gfp = nowait ? GFP_NOWAIT : GFP_KERNEL;
   801		sector_t sector = start >> SECTOR_SHIFT;
   802		sector_t nr_sects = len >> SECTOR_SHIFT;
   803		struct bio *prev = NULL, *bio;
   804		int err;
   805	
   806		if (!bdev_max_discard_sectors(bdev))
   807			return -EOPNOTSUPP;
   808		if (!(file_to_blk_mode(cmd->file) & BLK_OPEN_WRITE))
   809			return -EBADF;
   810		if (bdev_read_only(bdev))
   811			return -EPERM;
   812		err = blk_validate_byte_range(bdev, start, len);
   813		if (err)
   814			return err;
   815	
   816		err = filemap_invalidate_pages(bdev->bd_mapping, start,
   817						start + len - 1, nowait);
   818		if (err)
   819			return err;
   820	
   821		while (true) {
   822			bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp);
   823			if (!bio)
   824				break;
   825			if (nowait) {
   826				/*
   827				 * Don't allow multi-bio non-blocking submissions as
   828				 * subsequent bios may fail but we won't get a direct
   829				 * indication of that. Normally, the caller should
   830				 * retry from a blocking context.
   831				 */
   832				if (unlikely(nr_sects)) {
   833					bio_put(bio);
   834					return -EAGAIN;
   835				}
   836				bio->bi_opf |= REQ_NOWAIT;
   837			}
   838	
   839			prev = bio_chain_and_submit(prev, bio);
   840		}
   841		if (unlikely(!prev))
   842			return -EAGAIN;
   843		if (unlikely(nr_sects))
   844			bic->res = -EAGAIN;
   845	
   846		prev->bi_private = cmd;
   847		prev->bi_end_io = bio_cmd_bio_end_io;
   848		submit_bio(prev);
   849		return -EIOCBQUEUED;
   850	}
   851	
   852	int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 > 853	{
   854		struct block_device *bdev = I_BDEV(cmd->file->f_mapping->host);
   855		struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
   856		const struct io_uring_sqe *sqe = cmd->sqe;
   857		u32 cmd_op = cmd->cmd_op;
   858		uint64_t start, len;
   859	
   860		if (unlikely(sqe->ioprio || sqe->__pad1 || sqe->len ||
   861			     sqe->rw_flags || sqe->file_index))
   862			return -EINVAL;
   863	
   864		bic->res = 0;
   865		bic->nowait = issue_flags & IO_URING_F_NONBLOCK;
   866	
   867		start = READ_ONCE(sqe->addr);
   868		len = READ_ONCE(sqe->addr3);
   869	
   870		switch (cmd_op) {
   871		case BLOCK_URING_CMD_DISCARD:
   872			return blkdev_cmd_discard(cmd, bdev, start, len, bic->nowait);
   873		}
   874		return -EINVAL;
   875	}

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

