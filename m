Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC841226CF9
	for <lists+io-uring@lfdr.de>; Mon, 20 Jul 2020 19:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgGTRO1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 13:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728889AbgGTRO0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 13:14:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA64C061794;
        Mon, 20 Jul 2020 10:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=d45SJ+BOtrVprN5peIref8u4gVYNL9L8EWPr0CD0nOs=; b=Qn43UcExzwvyrabYv+bSaietLB
        7P14B46c5KQm8NZYBan4GaRIDj45LsNwNwArUaU7OZLcrqyZKS5Tx2dr5uXoM1glReH6jW+FCBglM
        XF+a8BwEWiZDXEDjXK9/kMkqlBKagUZH8nJ9xSCyIP/7MgjMAtfZ/gFCWM0Ywp01yCVpNBt0oSi4B
        k70PZdwvZ+vYVilV9Nz8vXzLSrpSG8VrAPGlioDQ04QqEWiSM/D337Su2iMlGk/DuUJSc7xtlxu/E
        T9mqc5nb+1xZYcUoVVltrip1njtJjF4677m/yH6bIeCltwnH6o7AQ4eEqxD+WAYKME/lPsa0VsOlB
        hVNDoRcg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxZMm-0005hb-71; Mon, 20 Jul 2020 17:14:16 +0000
Date:   Mon, 20 Jul 2020 18:14:16 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, Matias Bj??rling <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200720171416.GY12769@casper.infradead.org>
References: <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
 <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org>
 <20200710134824.GK12769@casper.infradead.org>
 <20200710134932.GA16257@infradead.org>
 <20200710135119.GL12769@casper.infradead.org>
 <CA+1E3rKOZUz7oZ_DGW6xZPQaDu+T5iEKXctd+gsJw05VwpGQSQ@mail.gmail.com>
 <CA+1E3r+j=amkEg-_KUKSiu6gt2TRU6AU-_jwnB1C6wHHKnptfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3r+j=amkEg-_KUKSiu6gt2TRU6AU-_jwnB1C6wHHKnptfQ@mail.gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 20, 2020 at 10:19:57PM +0530, Kanchan Joshi wrote:
> On Fri, Jul 10, 2020 at 7:41 PM Kanchan Joshi <joshiiitr@gmail.com> wrote:
> > If we are doing this for zone-append (and not general cases), "__s64
> > res64" should work -.
> > 64 bits = 1 (sign) + 23 (bytes-copied: cqe->res) + 40
> > (written-location: chunk_sector bytes limit)

No, don't do this.

 struct io_uring_cqe {
	__u64   user_data;      /* sqe->data submission passed back */
-	__s32   res;            /* result code for this event */
-	__u32   flags;
+	union {
+		struct {
+			__s32   res;    /* result code for this event */
+			__u32   flags;
+		};
+		__s64		res64;
+	};
 };

Return the value in bytes in res64, or a negative errno.  Done.
			
>   * IO completion data structure (Completion Queue Entry)
>   */
>  struct io_uring_cqe {
> -       __u64   user_data;      /* sqe->data submission passed back */
> -       __s32   res;            /* result code for this event */
> -       __u32   flags;
> +       __u64   user_data;      /* sqe->data submission passed back */
> +        union {
> +                struct {
> +                        __s32   res;            /* result code for
> this event */
> +                        __u32   flags;
> +                };
> +               /* Alternate for zone-append */
> +               struct {
> +                       union {
> +                               /*
> +                                * kernel uses this to store append result
> +                                * Most significant 23 bits to return number of
> +                                * bytes or error, and least significant 41 bits
> +                                * to return zone-relative offset in bytes
> +                                * */
> +                               __s64 res64;
> +                               /*for user-space ease, kernel does not use*/
> +                               struct {
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +                                       __u64 append_offset :
> APPEND_OFFSET_BITS;
> +                                       __s32 append_res : APPEND_RES_BITS;
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +                                       __s32 append_res : APPEND_RES_BITS;
> +                                       __u64 append_offset :
> APPEND_OFFSET_BITS;
> +#endif
> +                               }__attribute__ ((__packed__));
> +                       };
> +                };
> +        };
>  };
> 
> -- 
> Joshi
