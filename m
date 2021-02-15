Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D86331BBF5
	for <lists+io-uring@lfdr.de>; Mon, 15 Feb 2021 16:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhBOPL6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Feb 2021 10:11:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:18469 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhBOPKb (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 15 Feb 2021 10:10:31 -0500
IronPort-SDR: VVRlfjg4gLCYghzP12YT46DeLJaio95P9FNvdmc9EBOMB1w9LV9S47vnqSq7A9VjmDYXkrclW4
 WvEg4oYLQvSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="169835634"
X-IronPort-AV: E=Sophos;i="5.81,180,1610438400"; 
   d="gz'50?scan'50,208,50";a="169835634"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 07:09:40 -0800
IronPort-SDR: D9oQpDO9392vOPOw7f+TIHXnqGyjYHncrSPR9S/01eWEQc2nUhCJZI2y6MG1G+O34Z318SEHub
 eVIM7YmtN1WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,180,1610438400"; 
   d="gz'50?scan'50,208,50";a="512228299"
Received: from lkp-server02.sh.intel.com (HELO cd560a204411) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 15 Feb 2021 07:09:37 -0800
Received: from kbuild by cd560a204411 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lBfVI-0007Mj-JQ; Mon, 15 Feb 2021 15:09:36 +0000
Date:   Mon, 15 Feb 2021 23:09:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alexey Gladkov <gladkov.alexey@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-mm@kvack.org
Cc:     kbuild-all@lists.01.org, Alexey Gladkov <legion@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v6 6/7] Reimplement RLIMIT_MEMLOCK on top of ucounts
Message-ID: <202102152322.HTmdsPl3-lkp@intel.com>
References: <04cdc5d6da93511c0493612581b319b2255ea3d6.1613392826.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <04cdc5d6da93511c0493612581b319b2255ea3d6.1613392826.git.gladkov.alexey@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alexey,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kselftest/next]
[also build test ERROR on linux/master linus/master v5.11 next-20210212]
[cannot apply to hnaz-linux-mm/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Alexey-Gladkov/Count-rlimits-in-each-user-namespace/20210215-204524
base:   https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git next
config: xtensa-common_defconfig (attached as .config)
compiler: xtensa-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/f009495a8def89a71b9e0b9025a39379d6f9097d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Alexey-Gladkov/Count-rlimits-in-each-user-namespace/20210215-204524
        git checkout f009495a8def89a71b9e0b9025a39379d6f9097d
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=xtensa 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ipc/shm.c: In function 'newseg':
>> ipc/shm.c:653:5: error: passing argument 4 of 'hugetlb_file_setup' from incompatible pointer type [-Werror=incompatible-pointer-types]
     653 |     &shp->mlock_cred, HUGETLB_SHMFS_INODE,
         |     ^~~~~~~~~~~~~~~~
         |     |
         |     const struct cred **
   In file included from ipc/shm.c:30:
   include/linux/hugetlb.h:457:17: note: expected 'struct cred **' but argument is of type 'const struct cred **'
     457 |   struct cred **cred, int creat_flags,
         |   ~~~~~~~~~~~~~~^~~~
   cc1: some warnings being treated as errors


vim +/hugetlb_file_setup +653 ipc/shm.c

   592	
   593	/**
   594	 * newseg - Create a new shared memory segment
   595	 * @ns: namespace
   596	 * @params: ptr to the structure that contains key, size and shmflg
   597	 *
   598	 * Called with shm_ids.rwsem held as a writer.
   599	 */
   600	static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
   601	{
   602		key_t key = params->key;
   603		int shmflg = params->flg;
   604		size_t size = params->u.size;
   605		int error;
   606		struct shmid_kernel *shp;
   607		size_t numpages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
   608		struct file *file;
   609		char name[13];
   610		vm_flags_t acctflag = 0;
   611	
   612		if (size < SHMMIN || size > ns->shm_ctlmax)
   613			return -EINVAL;
   614	
   615		if (numpages << PAGE_SHIFT < size)
   616			return -ENOSPC;
   617	
   618		if (ns->shm_tot + numpages < ns->shm_tot ||
   619				ns->shm_tot + numpages > ns->shm_ctlall)
   620			return -ENOSPC;
   621	
   622		shp = kvmalloc(sizeof(*shp), GFP_KERNEL);
   623		if (unlikely(!shp))
   624			return -ENOMEM;
   625	
   626		shp->shm_perm.key = key;
   627		shp->shm_perm.mode = (shmflg & S_IRWXUGO);
   628		shp->mlock_cred = NULL;
   629	
   630		shp->shm_perm.security = NULL;
   631		error = security_shm_alloc(&shp->shm_perm);
   632		if (error) {
   633			kvfree(shp);
   634			return error;
   635		}
   636	
   637		sprintf(name, "SYSV%08x", key);
   638		if (shmflg & SHM_HUGETLB) {
   639			struct hstate *hs;
   640			size_t hugesize;
   641	
   642			hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK);
   643			if (!hs) {
   644				error = -EINVAL;
   645				goto no_file;
   646			}
   647			hugesize = ALIGN(size, huge_page_size(hs));
   648	
   649			/* hugetlb_file_setup applies strict accounting */
   650			if (shmflg & SHM_NORESERVE)
   651				acctflag = VM_NORESERVE;
   652			file = hugetlb_file_setup(name, hugesize, acctflag,
 > 653					&shp->mlock_cred, HUGETLB_SHMFS_INODE,
   654					(shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK);
   655		} else {
   656			/*
   657			 * Do not allow no accounting for OVERCOMMIT_NEVER, even
   658			 * if it's asked for.
   659			 */
   660			if  ((shmflg & SHM_NORESERVE) &&
   661					sysctl_overcommit_memory != OVERCOMMIT_NEVER)
   662				acctflag = VM_NORESERVE;
   663			file = shmem_kernel_file_setup(name, size, acctflag);
   664		}
   665		error = PTR_ERR(file);
   666		if (IS_ERR(file)) {
   667			shp->mlock_cred = NULL;
   668			goto no_file;
   669		}
   670	
   671		shp->shm_cprid = get_pid(task_tgid(current));
   672		shp->shm_lprid = NULL;
   673		shp->shm_atim = shp->shm_dtim = 0;
   674		shp->shm_ctim = ktime_get_real_seconds();
   675		shp->shm_segsz = size;
   676		shp->shm_nattch = 0;
   677		shp->shm_file = file;
   678		shp->shm_creator = current;
   679	
   680		/* ipc_addid() locks shp upon success. */
   681		error = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
   682		if (error < 0)
   683			goto no_id;
   684	
   685		list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
   686	
   687		/*
   688		 * shmid gets reported as "inode#" in /proc/pid/maps.
   689		 * proc-ps tools use this. Changing this will break them.
   690		 */
   691		file_inode(file)->i_ino = shp->shm_perm.id;
   692	
   693		ns->shm_tot += numpages;
   694		error = shp->shm_perm.id;
   695	
   696		ipc_unlock_object(&shp->shm_perm);
   697		rcu_read_unlock();
   698		return error;
   699	
   700	no_id:
   701		ipc_update_pid(&shp->shm_cprid, NULL);
   702		ipc_update_pid(&shp->shm_lprid, NULL);
   703		if (is_file_hugepages(file) && shp->mlock_cred)
   704			user_shm_unlock(size, shp->mlock_cred);
   705		fput(file);
   706		ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
   707		return error;
   708	no_file:
   709		call_rcu(&shp->shm_perm.rcu, shm_rcu_free);
   710		return error;
   711	}
   712	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--dDRMvlgZJXvWKvBx
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
BGcKPxI1hcHtvHcLaGzo/wPiRAJv66cAAA==

--dDRMvlgZJXvWKvBx--
