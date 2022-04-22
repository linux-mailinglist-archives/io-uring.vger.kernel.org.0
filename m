Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB8950B8CC
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 15:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbiDVNoI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 09:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443287AbiDVNoF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 09:44:05 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA22583BA
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 06:41:06 -0700 (PDT)
Received: from [192.168.88.87] (unknown [36.72.213.118])
        by gnuweeb.org (Postfix) with ESMTPSA id 3920F7E3B1;
        Fri, 22 Apr 2022 13:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1650634865;
        bh=VYb4boo4SXx7MPWX7XHptTSWmgp2SWke6M3Vo6QWbiI=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=YnghtjfAmG2a9WkVmILfnHdvEQC/lmNd/X501OL/SvqH09lh7nFl09qenZk4G6qwX
         E+a7FrFLP9HyDVI/MT+VYBXA68DIN5K2fk4XwTGF+akfVWTylwa3Q2d50LabQ7iygV
         tLIPs5U0C6xizgw1SqviiYAGQnnnLhdb2LAD1pn+03QQXrq+xq0o8ZyN2dhQVfel69
         iR/suusdSv1Gj/cjbUMYJ0l0voh7SySg8iTT8DJtSlrRcH4nZ+4UhunOxcdcVrLSNt
         NfMJYbTXo7jCqAGaIlyiyWAlZpgDLUcuamHTB8xdvo0OtuE+IXwrz8wiU7SULRrAif
         6OP54nC6NiE9A==
Message-ID: <eb7c07c1-fc2a-a44c-68cb-c98568912d6f@gnuweeb.org>
Date:   Fri, 22 Apr 2022 20:40:58 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        kernel-team@fb.com
References: <20220422114815.1124921-1-dylany@fb.com>
 <20220422114815.1124921-7-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing 6/7] test: add make targets for each test
In-Reply-To: <20220422114815.1124921-7-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/22 6:48 PM, Dylan Yudaken wrote:
> Add a make target runtests-parallel which can run tests in parallel.
> This is very useful to quickly run all the tests locally with
>    $ make -j runtests-parallel
> 
> Signed-off-by: Dylan Yudaken <dylany@fb.com>

Two comments below...

>   test/Makefile          | 10 +++++++++-
>   test/runtests-quiet.sh | 10 ++++++++++
>   2 files changed, 19 insertions(+), 1 deletion(-)
>   create mode 100755 test/runtests-quiet.sh

I suggest to add the following to the main Makefile:
```
runtests-parallel: all
	+$(MAKE) -C test runtests-parallel
```

So we can do this directly:
```
    make -j runtests-parallel;
```
instead of doing this:
```
    cd test;
    make -j runtests-parallel;
```

> -.PHONY: all install clean runtests runtests-loop
> +%.run_test: %.t
> +	@./runtests-quiet.sh $<
> +
> +runtests-parallel: $(run_test_targets)
> +	@echo "All tests passed"

Note that this parallel thing is doing:

    @./runtests-quiet.sh $THE_TEST_FILE

^ That thing is not a problem. But the ./runtests-quiet.sh exit code is.
> diff --git a/test/runtests-quiet.sh b/test/runtests-quiet.sh
> new file mode 100755
> index 0000000..ba9fe2b
> --- /dev/null
> +++ b/test/runtests-quiet.sh
> @@ -0,0 +1,10 @@
> +#!/usr/bin/env bash
> +
> +TESTS=("$@")
> +RESULT_FILE=$(mktemp)
> +./runtests.sh "${TESTS[@]}" 2>&1 > $RESULT_FILE
> +RET="$?"
> +if [ "${RET}" -ne 0 ]; then
> +    cat $RESULT_FILE
> +fi
> +rm $RESULT_FILE

This script's exit code doesn't necessarily represent the exit code of
the `./runtests.sh "${TESTS[@]}"`, so you have to add `exit $RET` at the
end of the script. Otherwise, the Makefile will always print "All tests
passed" even if we have tests failed.

-- 
Ammar Faizi
