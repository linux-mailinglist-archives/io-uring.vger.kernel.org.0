Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB25F565D72
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 20:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiGDSS7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 14:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGDSS6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 14:18:58 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5DF397
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 11:18:57 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
        by gnuweeb.org (Postfix) with ESMTPSA id 879588027A
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 18:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656958737;
        bh=4bamFxNseqOAdjaf8gcFT9mNE1nq/gv28ieuWp/3A4M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=klFd6dT1T2pgxXqQ45XoYdY+jfvULPzEPBJ3yDC8fjq6TKVW3SrHqltLy9FQnjCIl
         RlLGEU229HpMufJaN1FcfhWA5YVIayEw72pk3kEyzI33TinxqRYEkbFzTJPawuUZfi
         DYJk8uacVkeHcj7cJeSb+Y2suJlzlsCy9PjeHosw/L2ppgMfIi2yxXFskdnuEoLOXV
         z0HJoDn7AKBQRo0BtuAcvDkmvuN5DhC7Vl+5359qkAbj0mifJLR6tL8vmpg/gykopO
         XBEevtiveWM/ldWie+K8JBt9Di8ncVarZt0IqAo7D9U49qpnARQ/ncKVwtnOXBo41M
         npXA7li/cNxkg==
Received: by mail-lf1-f53.google.com with SMTP id a13so16948634lfr.10
        for <io-uring@vger.kernel.org>; Mon, 04 Jul 2022 11:18:57 -0700 (PDT)
X-Gm-Message-State: AJIora8ZxtMwiCOK0aqyc+VO2Tz8crN8A1i9Z5Gpu0yrgdCShWKe29d0
        viBR1LqZnWQ/+p7KPI7hPqZYDlxmvFtNyasNV0g=
X-Google-Smtp-Source: AGRyM1sy1amy2WDUO75RIkPHnxu1u17v/ced0Rw5ltuSIfhflxO2eq2KvIpNyeIVWf4sDvYpZ90oC7cMagW/yGEBWpU=
X-Received: by 2002:ac2:4e0f:0:b0:481:df0:94a with SMTP id e15-20020ac24e0f000000b004810df0094amr18894690lfr.655.1656958735640;
 Mon, 04 Jul 2022 11:18:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220704174858.329326-1-ammar.faizi@intel.com> <20220704174858.329326-6-ammar.faizi@intel.com>
In-Reply-To: <20220704174858.329326-6-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Tue, 5 Jul 2022 01:18:44 +0700
X-Gmail-Original-Message-ID: <CAOG64qPdVWFE0ZCie3NiDJb42u78ZNtmOmEW=-=oLE6VAn80TQ@mail.gmail.com>
Message-ID: <CAOG64qPdVWFE0ZCie3NiDJb42u78ZNtmOmEW=-=oLE6VAn80TQ@mail.gmail.com>
Subject: Re: [PATCH liburing v3 05/10] arch/aarch64: lib: Add
 `get_page_size()` function
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 5, 2022 at 12:54 AM Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> A prep patch to add aarch64 nolibc support.
>
> aarch64 supports three values of page size: 4K, 16K, and 64K which are
> selected at kernel compilation time. Therefore, we can't hard code the
> page size for this arch. Utilize open(), read() and close() syscall to
> find the page size from /proc/self/auxv. For more details about the
> auxv data structure, check the link below [1].
>
> v3:
>   - Split open/read/close in get_page_size() into a new function.
>   - Cache the fallback value when we fail on the syscalls.
>   - No need to init the static var to zero.
>
> v2:
>   - Fallback to 4K if the syscall fails.
>   - Cache the page size after read as suggested by Jens.
>
> Link: https://github.com/torvalds/linux/blob/v5.19-rc4/fs/binfmt_elf.c#L260 [1]
> Link: https://lore.kernel.org/io-uring/3895dbe1-8d5f-cf53-e94b-5d1545466de1@kernel.dk
> Link: https://lore.kernel.org/io-uring/8bfba71c-55d7-fb49-6593-4d0f9d9c3611@kernel.dk
> Link: https://lore.kernel.org/io-uring/49ed1c4c-46ca-15c4-f288-f6808401b0ff@kernel.dk
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
[...]
> +static inline long __get_page_size(void)
> +{
> +       static const long fallback_ret = 4096;
> +       Elf64_Off buf[2];
> +       long ret;
> +       int fd;
> +
> +       fd = __sys_open("/proc/self/auxv", O_RDONLY, 0);
> +       if (fd < 0)
> +               return fallback_ret;
> +
> +       while (1) {
> +               ssize_t x;
> +
> +               x = __sys_read(fd, buf, sizeof(buf));
> +               if (x < sizeof(buf)) {
> +                       ret = fallback_ret;
> +                       break;
> +               }
> +
> +               if (buf[0] == AT_PAGESZ) {
> +                       ret = buf[1];
> +                       break;
> +               }
> +       }
> +
> +       __sys_close(fd);
> +       return ret;
> +}

fallback_ret var is not needed, just do this, simpler:

static inline long __get_page_size(void)
{
        Elf64_Off buf[2];
        long ret = 4096;
        int fd;

        fd = __sys_open("/proc/self/auxv", O_RDONLY, 0);
        if (fd < 0)
                return ret;

        while (1) {
                ssize_t x;

                x = __sys_read(fd, buf, sizeof(buf));
                if (x < sizeof(buf))
                        break;

                if (buf[0] == AT_PAGESZ) {
                        ret = buf[1];
                        break;
                }
        }

        __sys_close(fd);
        return ret;
}

with that simplification:

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
