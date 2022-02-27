Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB274C5F20
	for <lists+io-uring@lfdr.de>; Sun, 27 Feb 2022 22:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiB0VnZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Feb 2022 16:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiB0VnY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Feb 2022 16:43:24 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4AF64FC;
        Sun, 27 Feb 2022 13:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645998166; x=1677534166;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=4MO/GDGtXS6Dv1CRiErf5GTXWaiBkVdvSHdu4GIfpxU=;
  b=mf6D7+nu+Ms1A8i2L/k2qZbBJqlIFkNOBl8rYjPtcNj4ubnjUw+81URW
   0ryu3ISq6QW1sW24DNxpwyNnXqt69Q+YVUrLlIi5AWssMIJlJrZrDtJr3
   hRO0KMMVWPf2F46cIkCGvfJxPz+AcJva5zuTxGyQY6MVM+v3BesdBqFKT
   osCMJzdM9hbk4BhSPQA0I8a2N8s2XCqEdpIf2iLEXxPGuky2P6yB7HKHj
   3dr73JH3g5LiBgaBR/EoW6NLsMpDBGU/fVQtmPHt0qSQk2e79CY8r5HSo
   vjbhnYG4V0q34nsqQbhBbjbdI47xw30G+/Ea5i8ml7gleEG8/ZhVw0OMN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="233385087"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="233385087"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 13:42:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="708436226"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 27 Feb 2022 13:42:43 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nORJT-0006om-7e; Sun, 27 Feb 2022 21:42:43 +0000
Date:   Mon, 28 Feb 2022 05:42:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] io_uring: Add support for napi_busy_poll
Message-ID: <202202280543.0QW3T3id-lkp@intel.com>
References: <53ae4884ede7faab1f409ec635f723a0745d3656.1645981935.git.olivier@trillion01.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <53ae4884ede7faab1f409ec635f723a0745d3656.1645981935.git.olivier@trillion01.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Olivier,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[cannot apply to v5.17-rc5 next-20220225]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Olivier-Langlois/io_uring-=
Add-support-for-napi_busy_poll/20220228-012140
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git =
2293be58d6a18cab800e25e42081bacb75c05752
config: mips-buildonly-randconfig-r006-20220227 (https://download.01.org/0d=
ay-ci/archive/20220228/202202280543.0QW3T3id-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc=
04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=3D1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/=
make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/0day-ci/linux/commit/65e72f78c66272f7cf0e87dfe=
ef88f5b79de2d91
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Olivier-Langlois/io_uring-Add-supp=
ort-for-napi_busy_poll/20220228-012140
        git checkout 65e72f78c66272f7cf0e87dfeef88f5b79de2d91
        # save the config file to linux build tree
        COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=3D=
1 ARCH=3Dmips=20

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/io_uring.c:7840:3: warning: comparison of distinct pointer types ('ty=
peof ((to)) (aka 'long long and 'uint64_t (aka 'unsigned long long
   do_div(to, 1000);
   ^~~~~~~~~~~~~~~~
   include/asm-generic/div64.h:222:28: note: expanded from macro 'do_div'
   (void)(((typeof((n)) =3D=3D ((uint64_t ~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~=
~~~
   fatal error: error in backend: Nested variants found in inline asm strin=
g: ' .set push
   .set mips64r2
   .if ( 0x00 ) !=3D -1)) 0x00 ) !=3D -1)) : ($( static struct ftrace_branc=
h_data __attribute__((__aligned__(4))) __attribute__((__section__("_ftrace_=
branch"))) __if_trace =3D $( .func =3D __func__, .file =3D "arch/mips/inclu=
de/asm/atomic.h", .line =3D 155, $); 0x00 ) !=3D -1)) : $))) ) && ( 0 ); .s=
et push; .set mips64r2; .rept 1; sync 0x00; .endr; .set pop; .else; ; .endif
   1: ll $0, $1 # atomic_add
   addu $0, $2
   sc $0, $1
   beqz $0, 1b
   .set pop
   '
   PLEASE submit a bug report to https://github.com/llvm/llvm-project/issue=
s/ and include the crash backtrace, preprocessed source, and associated run=
 script.
   Stack dump:
   0. Program arguments: clang -Wp,-MMD,fs/.io_uring.o.d -nostdinc -Iarch/m=
ips/include -I./arch/mips/include/generated -Iinclude -I./include -Iarch/mi=
ps/include/uapi -I./arch/mips/include/generated/uapi -Iinclude/uapi -I./inc=
lude/generated/uapi -include include/linux/compiler-version.h -include incl=
ude/linux/kconfig.h -include include/linux/compiler_types.h -D__KERNEL__ -D=
VMLINUX_LOAD_ADDRESS=3D0xffffffff80002000 -DLINKER_LOAD_ADDRESS=3D0x8000200=
0 -DDATAOFFSET=3D0 -Qunused-arguments -fmacro-prefix-map=3D=3D -DKBUILD_EXT=
RA_WARN1 -Wall -Wundef -Werror=3Dstrict-prototypes -Wno-trigraphs -fno-stri=
ct-aliasing -fno-common -fshort-wchar -fno-PIE -Werror=3Dimplicit-function-=
declaration -Werror=3Dimplicit-int -Werror=3Dreturn-type -Wno-format-securi=
ty -std=3Dgnu89 --target=3Dmips-linux -fintegrated-as -Werror=3Dunknown-war=
ning-option -Werror=3Dignored-optimization-argument -mno-check-zero-divisio=
n -mabi=3D32 -G 0 -mno-abicalls -fno-pic -pipe -msoft-float -DGAS_HAS_SET_H=
ARDFLOAT -Wa,-msoft-float -ffreestanding -EB -fno-stack-check -march=3Dmips=
32 -Wa,--trap -DTOOLCHAIN_SUPPORTS_VIRT -Iarch/mips/include/asm/mach-lantiq=
 -Iarch/mips/include/asm/mach-lantiq/xway -Iarch/mips/include/asm/mach-gene=
ric -fno-asynchronous-unwind-tables -fno-delete-null-pointer-checks -Wno-fr=
ame-address -Wno-address-of-packed-member -O2 -Wframe-larger-than=3D1024 -f=
stack-protector-strong -Wimplicit-fallthrough -Wno-gnu -mno-global-merge -W=
no-unused-but-set-variable -Wno-unused-const-variable -ftrivial-auto-var-in=
it=3Dpattern -fno-stack-clash-protection -pg -Wdeclaration-after-statement =
-Wvla -Wno-pointer-sign -Wcast-function-type -Wno-array-bounds -fno-strict-=
overflow -fno-stack-check -Werror=3Ddate-time -Werror=3Dincompatible-pointe=
r-types -Wextra -Wunused -Wno-unused-parameter -Wmissing-declarations -Wmis=
sing-format-attribute -Wmissing-prototypes -Wold-style-definition -Wmissing=
-include-dirs -Wunused-but-set-variable -Wunused-const-variable -Wno-missin=
g-field-initializers -Wno-sign-compare -Wno-type-limits -I fs -I ./fs -DKBU=
ILD_MODFILE=3D"fs/io_uring" -DKBUILD_BASENAME=3D"io_uring" -DKBUILD_MODNAME=
=3D"io_uring" -D__KBUILD_MODNAME=3Dkmod_io_uring -c -o fs/io_uring.o fs/io_=
uring.c
   1. <eof> parser at end of file
   2. Code generation
   3. Running pass 'Function Pass Manager' on module 'fs/io_uring.c'.
   4. Running pass 'Mips Assembly Printer' on function '@io_uring_cancel_ge=
neric'
   #0 0x000055a23ff64d7f Signals.cpp:0:0
   #1 0x000055a23ff62c5c llvm::sys::CleanupOnSignal(unsigned long) (/opt/cr=
oss/clang-d271fc04d5/bin/clang-15+0x348ec5c)
   #2 0x000055a23fea2fd7 llvm::CrashRecoveryContext::HandleExit(int) (/opt/=
cross/clang-d271fc04d5/bin/clang-15+0x33cefd7)
   #3 0x000055a23ff5b30e llvm::sys::Process::Exit(int, bool) (/opt/cross/cl=
ang-d271fc04d5/bin/clang-15+0x348730e)
   #4 0x000055a23db86ccb (/opt/cross/clang-d271fc04d5/bin/clang-15+0x10b2cc=
b)
   #5 0x000055a23fea9a8c llvm::report_fatal_error(llvm::Twine const&, bool)=
 (/opt/cross/clang-d271fc04d5/bin/clang-15+0x33d5a8c)
   #6 0x000055a240bb35c0 llvm::AsmPrinter::emitInlineAsm(llvm::MachineInstr=
 const (/opt/cross/clang-d271fc04d5/bin/clang-15+0x40df5c0)
   #7 0x000055a240baf4f4 llvm::AsmPrinter::emitFunctionBody() (/opt/cross/c=
lang-d271fc04d5/bin/clang-15+0x40db4f4)
   #8 0x000055a23e5f0887 llvm::MipsAsmPrinter::runOnMachineFunction(llvm::M=
achineFunction&) (/opt/cross/clang-d271fc04d5/bin/clang-15+0x1b1c887)
   #9 0x000055a23f2ad54d llvm::MachineFunctionPass::runOnFunction(llvm::Fun=
ction&) (.part.53) MachineFunctionPass.cpp:0:0
   #10 0x000055a23f6f4807 llvm::FPPassManager::runOnFunction(llvm::Function=
&) (/opt/cross/clang-d271fc04d5/bin/clang-15+0x2c20807)
   #11 0x000055a23f6f4981 llvm::FPPassManager::runOnModule(llvm::Module&) (=
/opt/cross/clang-d271fc04d5/bin/clang-15+0x2c20981)
   #12 0x000055a23f6f54ff llvm::legacy::PassManagerImpl::run(llvm::Module&)=
 (/opt/cross/clang-d271fc04d5/bin/clang-15+0x2c214ff)
   #13 0x000055a24027f147 clang::EmitBackendOutput(clang::DiagnosticsEngine=
&, clang::HeaderSearchOptions const&, clang::CodeGenOptions const&, clang::=
TargetOptions const&, clang::LangOptions const&, llvm::StringRef, clang::Ba=
ckendAction, std::unique_ptr<llvm::raw_pwrite_stream, std::default_delete<l=
lvm::raw_pwrite_stream> >) (/opt/cross/clang-d271fc04d5/bin/clang-15+0x37ab=
147)
   #14 0x000055a240ecd693 clang::BackendConsumer::HandleTranslationUnit(cla=
ng::ASTContext&) (/opt/cross/clang-d271fc04d5/bin/clang-15+0x43f9693)
   #15 0x000055a2419a86e9 clang::ParseAST(clang::Sema&, bool, bool) (/opt/c=
ross/clang-d271fc04d5/bin/clang-15+0x4ed46e9)
   #16 0x000055a240ecc4cf clang::CodeGenAction::ExecuteAction() (/opt/cross=
/clang-d271fc04d5/bin/clang-15+0x43f84cf)
   #17 0x000055a2408cf561 clang::FrontendAction::Execute() (/opt/cross/clan=
g-d271fc04d5/bin/clang-15+0x3dfb561)
   #18 0x000055a240865faa clang::CompilerInstance::ExecuteAction(clang::Fro=
ntendAction&) (/opt/cross/clang-d271fc04d5/bin/clang-15+0x3d91faa)
   #19 0x000055a240993cbb (/opt/cross/clang-d271fc04d5/bin/clang-15+0x3ebfc=
bb)
   #20 0x000055a23db8827c cc1_main(llvm::ArrayRef<char char (/opt/cross/cla=
ng-d271fc04d5/bin/clang-15+0x10b427c)
   #21 0x000055a23db84f4b ExecuteCC1Tool(llvm::SmallVectorImpl<char driver.=
cpp:0:0
   #22 0x000055a2406fed95 void llvm::function_ref<void ()>::callback_fn<cla=
ng::driver::CC1Command::Execute(llvm::ArrayRef<llvm::Optional<llvm::StringR=
ef> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::alloca=
tor<char> const::'lambda'()>(long) Job.cpp:0:0
   #23 0x000055a23fea2e93 llvm::CrashRecoveryContext::RunSafely(llvm::funct=
ion_ref<void ()>) (/opt/cross/clang-d271fc04d5/bin/clang-15+0x33cee93)
   #24 0x000055a2406ff68e clang::driver::CC1Command::Execute(llvm::ArrayRef=
<llvm::Optional<llvm::StringRef> >, std::__cxx11::basic_string<char, std::c=
har_traits<char>, std::allocator<char> const (.part.216) Job.cpp:0:0
   #25 0x000055a2406d4267 clang::driver::Compilation::ExecuteCommand(clang:=
:driver::Command const&, clang::driver::Command const (/opt/cross/clang-d27=
1fc04d5/bin/clang-15+0x3c00267)
   #26 0x000055a2406d4c47 clang::driver::Compilation::ExecuteJobs(clang::dr=
iver::JobList const&, llvm::SmallVectorImpl<std::pair<int, clang::driver::C=
ommand >&) const (/opt/cross/clang-d271fc04d5/bin/clang-15+0x3c00c47)
   #27 0x000055a2406de2f9 clang::driver::Driver::ExecuteCompilation(clang::=
driver::Compilation&, llvm::SmallVectorImpl<std::pair<int, clang::driver::C=
ommand >&) (/opt/cross/clang-d271fc04d5/bin/clang-15+0x3c0a2f9)
   #28 0x000055a23daad63f main (/opt/cross/clang-d271fc04d5/bin/clang-15+0x=
fd963f)
   #29 0x00007f38edb9bd0a __libc_start_main (/lib/x86_64-linux-gnu/libc.so.=
6+0x26d0a)
   #30 0x000055a23db84a6a _start (/opt/cross/clang-d271fc04d5/bin/clang-15+=
0x10b0a6a)
   clang-15: error: clang frontend command failed with exit code 70 (use -v=
 to see invocation)
   clang version 15.0.0 (git://gitmirror/llvm_project d271fc04d5b97b12e6b79=
7c6067d3c96a8d7470e)
   Target: mips-unknown-linux
   Thread model: posix
   InstalledDir: /opt/cross/clang-d271fc04d5/bin
   clang-15: note: diagnostic msg:
   Makefile arch block certs crypto drivers fs include init ipc kernel lib =
mm net nr_bisected scripts security sound source usr virt


vim +7840 fs/io_uring.c

  7826=09
  7827	#ifdef CONFIG_NET_RX_BUSY_POLL
  7828	static void io_adjust_busy_loop_timeout(struct timespec64 *ts,
  7829						struct io_wait_queue *iowq)
  7830	{
  7831		unsigned busy_poll_to =3D READ_ONCE(sysctl_net_busy_poll);
  7832		struct timespec64 pollto =3D ns_to_timespec64(1000 * (s64)busy_poll=
_to);
  7833=09
  7834		if (timespec64_compare(ts, &pollto) > 0) {
  7835			*ts =3D timespec64_sub(*ts, pollto);
  7836			iowq->busy_poll_to =3D busy_poll_to;
  7837		} else {
  7838			s64 to =3D timespec64_to_ns(ts);
  7839=09
> 7840			do_div(to, 1000);
  7841			iowq->busy_poll_to =3D to;
  7842			ts->tv_sec =3D 0;
  7843			ts->tv_nsec =3D 0;
  7844		}
  7845	}
  7846=09

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
