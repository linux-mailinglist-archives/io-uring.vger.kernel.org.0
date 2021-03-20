Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A2D342E82
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 18:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCTRGH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 13:06:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:62730 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhCTRFe (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 20 Mar 2021 13:05:34 -0400
IronPort-SDR: 4w2O0dFyhGYoC5J5Ezo7L39MEUO4nMh1KxFfvlbFTNB+wjTPbOBvhrWBy7DenZV9f8JdtP1PY4
 Gpd91jHrxA5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9929"; a="177194015"
X-IronPort-AV: E=Sophos;i="5.81,264,1610438400"; 
   d="gz'50?scan'50,208,50";a="177194015"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2021 10:05:33 -0700
IronPort-SDR: WUML1g3q7G88rY++b4PTyzZpPOrn3at9dXd7eDmQl2NCSdInKPgunQxo6AXdIz+6H7ifN8vnMZ
 vopS2UxJV8bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,264,1610438400"; 
   d="gz'50?scan'50,208,50";a="375258728"
Received: from lkp-server02.sh.intel.com (HELO 1c294c63cb86) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 20 Mar 2021 10:05:30 -0700
Received: from kbuild by 1c294c63cb86 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lNf2Y-0002go-1f; Sat, 20 Mar 2021 17:05:30 +0000
Date:   Sun, 21 Mar 2021 01:05:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        torvalds@linux-foundation.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCHSET 0/2] PF_IO_WORKER signal tweaks
Message-ID: <202103210005.vdpvbxqj-lkp@intel.com>
References: <20210320153832.1033687-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20210320153832.1033687-1-axboe@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jens,

I love your patch! Yet something to improve:

[auto build test ERROR on linux/master]
[also build test ERROR on tip/sched/core linus/master v5.12-rc3 next-20210319]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Jens-Axboe/PF_IO_WORKER-signal-tweaks/20210320-234247
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git a74e6a014c9d4d4161061f770c9b4f98372ac778
config: s390-randconfig-r014-20210321 (attached as .config)
compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 436c6c9c20cc522c92a923440a5fc509c342a7db)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/05c70f370b93f3bf555e63293d43a82aab2fcdf3
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jens-Axboe/PF_IO_WORKER-signal-tweaks/20210320-234247
        git checkout 05c70f370b93f3bf555e63293d43a82aab2fcdf3
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=s390 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:15:
   In file included from include/linux/mm.h:707:
   In file included from include/linux/huge_mm.h:8:
   In file included from include/linux/fs.h:33:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
>> include/linux/sched/signal.h:673:33: error: expected ';' after return statement
           return p1->signal == p2->signal
                                          ^
                                          ;
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:33:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:36:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:105:32: note: expanded from macro '__swab16'
           (__builtin_constant_p((__u16)(x)) ?     \
                                         ^
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:33:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:36:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:106:21: note: expanded from macro '__swab16'
           ___constant_swab16(x) :                 \
                              ^
   include/uapi/linux/swab.h:15:12: note: expanded from macro '___constant_swab16'
           (((__u16)(x) & (__u16)0x00ffU) << 8) |                  \
                     ^
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:33:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:36:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:106:21: note: expanded from macro '__swab16'
           ___constant_swab16(x) :                 \
                              ^
   include/uapi/linux/swab.h:16:12: note: expanded from macro '___constant_swab16'
           (((__u16)(x) & (__u16)0xff00U) >> 8)))
                     ^
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:33:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:36:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:107:12: note: expanded from macro '__swab16'
           __fswab16(x))
                     ^
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:33:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:36:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
--
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:15:
   In file included from include/linux/mm.h:707:
   In file included from include/linux/huge_mm.h:8:
   In file included from include/linux/fs.h:33:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
>> include/linux/sched/signal.h:673:33: error: expected ';' after return statement
           return p1->signal == p2->signal
                                          ^
                                          ;
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:33:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:36:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:105:32: note: expanded from macro '__swab16'
           (__builtin_constant_p((__u16)(x)) ?     \
                                         ^
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:33:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:36:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:106:21: note: expanded from macro '__swab16'
           ___constant_swab16(x) :                 \
                              ^
   include/uapi/linux/swab.h:15:12: note: expanded from macro '___constant_swab16'
           (((__u16)(x) & (__u16)0x00ffU) << 8) |                  \
                     ^
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:33:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:36:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:106:21: note: expanded from macro '__swab16'
           ___constant_swab16(x) :                 \
                              ^
   include/uapi/linux/swab.h:16:12: note: expanded from macro '___constant_swab16'
           (((__u16)(x) & (__u16)0xff00U) >> 8)))
                     ^
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:33:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:36:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:107:12: note: expanded from macro '__swab16'
           __fswab16(x))
                     ^
   In file included from arch/s390/kernel/asm-offsets.c:11:
   In file included from include/linux/kvm_host.h:33:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:36:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:


vim +673 include/linux/sched/signal.h

   669	
   670	static inline
   671	bool same_thread_group_account(struct task_struct *p1, struct task_struct *p2)
   672	{
 > 673		return p1->signal == p2->signal
   674	}
   675	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--qDbXVdCdHGoSgWSk
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
MisNZi6Res3Je1eK4/ctrcv/A9jmHqgq6QAA

--qDbXVdCdHGoSgWSk--
