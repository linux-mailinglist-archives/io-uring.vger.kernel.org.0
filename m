Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287875A95E1
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 13:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiIALpJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 07:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiIALpH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 07:45:07 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADA02D1FF
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 04:45:05 -0700 (PDT)
Received: from [192.168.210.80] (unknown [182.2.73.109])
        by gnuweeb.org (Postfix) with ESMTPSA id 9726D80866;
        Thu,  1 Sep 2022 11:45:02 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662032705;
        bh=NfPJX/p+VtiuSko08lhlQQW79+Tx+PL42dX85BzxqtM=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=V5rD7CQ11ql3jqlCz+4FtEZiRP0PZZcDFD0R+xoR0K8nQz3kui49fVgSlx2yjoiCf
         1euRuONzxoz35xrOXW/YYFem/ottbGcMcew8ExrAcWvl2tE9jucGsPLnrhqapelnHy
         ho8cUJwLtugdk0Nu3m0HpPP5yojDa63UeC1ZJhpzDHPlamtvvx5viLhBsQiBs9GBNB
         Cuy8umkEo4mkCgGcUeScvvBG1rvT5Cb2WV9ZhmRX62ivxbEVT5EgktmK44gJDbOnZ7
         J6WaM1RjyrsgS/EfEMjX3H/HIPdpmO3k7L95tKqlR3F50p0JfIT8wd834NMg69MAXB
         18pCvya8MF3ug==
Message-ID: <918facd1-78ba-2de7-693a-5f8c65ea2fcd@gnuweeb.org>
Date:   Thu, 1 Sep 2022 18:44:59 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20220901093303.1974274-1-dylany@fb.com>
 <20220901093303.1974274-13-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v2 12/12] shutdown test: bind to ephemeral port
In-Reply-To: <20220901093303.1974274-13-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/22 4:33 PM, Dylan Yudaken wrote:
> This test would occasionally fail if the chosen port was in use. Rather
> bind to an ephemeral port which will not be in use.
> 
> Signed-off-by: Dylan Yudaken<dylany@fb.com>
> ---
>   test/shutdown.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/test/shutdown.c b/test/shutdown.c
> index 14c7407b5492..c584893bdd28 100644
> --- a/test/shutdown.c
> +++ b/test/shutdown.c
> @@ -30,6 +30,7 @@ int main(int argc, char *argv[])
>   	int32_t recv_s0;
>   	int32_t val = 1;
>   	struct sockaddr_in addr;
> +	socklen_t addrlen;
>   
>   	if (argc > 1)
>   		return 0;
> @@ -44,7 +45,7 @@ int main(int argc, char *argv[])
>   	assert(ret != -1);
>   
>   	addr.sin_family = AF_INET;
> -	addr.sin_port = htons((rand() % 61440) + 4096);
> +	addr.sin_port = 0;
>   	addr.sin_addr.s_addr = inet_addr("127.0.0.1");
>   
>   	ret = bind(recv_s0, (struct sockaddr*)&addr, sizeof(addr));
> @@ -52,6 +53,10 @@ int main(int argc, char *argv[])
>   	ret = listen(recv_s0, 128);
>   	assert(ret != -1);
>   
> +	addrlen = (socklen_t)sizeof(addr);
> +	assert(!getsockname(recv_s0, (struct sockaddr *)&addr,
> +			    &addrlen));
> +

Hi Jens,
Hi Dylan,

I like the idea of using an ephemeral port. This is the most
reliable way to get a port number that's not in use. However,
we have many places that do this rand() mechanism to generate
a port number. This patch only fixes shutdown.c.

What do you think of creating a new function helper like this?

int t_bind_ephemeral(int fd, struct sockaddr_in *addr)
{
         socklen_t addrlen;
         int ret;

         addr->sin_port = 0;
         if (bind(fd, (struct sockaddr*)addr, sizeof(*addr)))
                 return -errno;

         addrlen = sizeof(*addr);
         assert(!getsockname(fd, (struct sockaddr *)&addr, &addrlen));
         return 0;
}

We can avoid code duplication by doing that. I can do that.
If everybody agrees, let's drop this patch and I will wire up
t_bind_ephemeral() function.

Yes? No?

-- 
Ammar Faizi
