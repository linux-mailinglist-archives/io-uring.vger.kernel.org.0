Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B347562184
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 19:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbiF3RxR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 13:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbiF3RxQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 13:53:16 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3257D14D2E;
        Thu, 30 Jun 2022 10:53:14 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:44732)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1o6yLn-0020mB-0Z; Thu, 30 Jun 2022 11:53:11 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:58068 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1o6yLl-001wdx-Pt; Thu, 30 Jun 2022 11:53:10 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, nvdimm@lists.linux.dev,
        io-uring@vger.kernel.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, Ira Weiny <ira.weiny@intel.com>
References: <20220630163527.9776-1-fmdefrancesco@gmail.com>
Date:   Thu, 30 Jun 2022 12:38:08 -0500
In-Reply-To: <20220630163527.9776-1-fmdefrancesco@gmail.com> (Fabio M. De
        Francesco's message of "Thu, 30 Jun 2022 18:35:27 +0200")
Message-ID: <8735fmqcfz.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1o6yLl-001wdx-Pt;;;mid=<8735fmqcfz.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19nGDcBXv1cJKDV99uQtYu50l8eqi94dLE=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;"Fabio M. De Francesco" <fmdefrancesco@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 601 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 11 (1.8%), b_tie_ro: 9 (1.6%), parse: 1.61 (0.3%),
         extract_message_metadata: 20 (3.3%), get_uri_detail_list: 3.2 (0.5%),
        tests_pri_-1000: 17 (2.9%), tests_pri_-950: 1.40 (0.2%),
        tests_pri_-900: 1.10 (0.2%), tests_pri_-90: 109 (18.1%), check_bayes:
        107 (17.7%), b_tokenize: 12 (1.9%), b_tok_get_all: 10 (1.7%),
        b_comp_prob: 4.7 (0.8%), b_tok_touch_all: 76 (12.6%), b_finish: 1.04
        (0.2%), tests_pri_0: 426 (70.8%), check_dkim_signature: 0.89 (0.1%),
        check_dkim_adsp: 3.2 (0.5%), poll_dns_idle: 0.80 (0.1%), tests_pri_10:
        2.1 (0.4%), tests_pri_500: 8 (1.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] fs: Replace kmap{,_atomic}() with kmap_local_page()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

"Fabio M. De Francesco" <fmdefrancesco@gmail.com> writes:

> The use of kmap() and kmap_atomic() are being deprecated in favor of
> kmap_local_page().
>
> With kmap_local_page(), the mappings are per thread, CPU local and not
> globally visible. Furthermore, the mappings can be acquired from any
> context (including interrupts).
>
> Therefore, use kmap_local_page() in exec.c because these mappings are per
> thread, CPU local, and not globally visible.
>
> Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
> HIGHMEM64GB enabled.

Can someone please refresh my memory on what is going on.

I remember there were limitations that kmap_atomic had that are hard to
meet so something I think it was kmap_local was invented and created
to be the kmap_atomic replacement.

What are the requirements on kmap_local?  In copy_strings
kmap is called in contexts that can sleep in page faults so any
nearly any requirement except a thread local use is invalidated.

As you have described kmap_local above it does not sound like kmap_local
is safe in this context, but that could just be a problem in description
that my poor memory does is not recalling the necessary details to
correct.

Eric

> Suggested-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> ---
>  fs/exec.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 0989fb8472a1..4a2129c0d422 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -583,11 +583,11 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
>  
>  				if (kmapped_page) {
>  					flush_dcache_page(kmapped_page);
> -					kunmap(kmapped_page);
> +					kunmap_local(kaddr);
>  					put_arg_page(kmapped_page);
>  				}
>  				kmapped_page = page;
> -				kaddr = kmap(kmapped_page);
> +				kaddr = kmap_local_page(kmapped_page);
>  				kpos = pos & PAGE_MASK;
>  				flush_arg_page(bprm, kpos, kmapped_page);
>  			}
> @@ -601,7 +601,7 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
>  out:
>  	if (kmapped_page) {
>  		flush_dcache_page(kmapped_page);
> -		kunmap(kmapped_page);
> +		kunmap_local(kaddr);
>  		put_arg_page(kmapped_page);
>  	}
>  	return ret;
> @@ -883,11 +883,11 @@ int transfer_args_to_stack(struct linux_binprm *bprm,
>  
>  	for (index = MAX_ARG_PAGES - 1; index >= stop; index--) {
>  		unsigned int offset = index == stop ? bprm->p & ~PAGE_MASK : 0;
> -		char *src = kmap(bprm->page[index]) + offset;
> +		char *src = kmap_local_page(bprm->page[index]) + offset;
>  		sp -= PAGE_SIZE - offset;
>  		if (copy_to_user((void *) sp, src, PAGE_SIZE - offset) != 0)
>  			ret = -EFAULT;
> -		kunmap(bprm->page[index]);
> +		kunmap_local(src);
>  		if (ret)
>  			goto out;
>  	}
> @@ -1680,13 +1680,13 @@ int remove_arg_zero(struct linux_binprm *bprm)
>  			ret = -EFAULT;
>  			goto out;
>  		}
> -		kaddr = kmap_atomic(page);
> +		kaddr = kmap_local_page(page);
>  
>  		for (; offset < PAGE_SIZE && kaddr[offset];
>  				offset++, bprm->p++)
>  			;
>  
> -		kunmap_atomic(kaddr);
> +		kunmap_local(kaddr);
>  		put_arg_page(page);
>  	} while (offset == PAGE_SIZE);
