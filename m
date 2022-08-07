Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57BD58BC82
	for <lists+io-uring@lfdr.de>; Sun,  7 Aug 2022 20:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbiHGSp4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Aug 2022 14:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiHGSpz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Aug 2022 14:45:55 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777EE958D
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 11:45:53 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220807184548epoutp035eb2013d367aa7f15e20c0a7a5585b69~JJGO1CqYI2485424854epoutp03O
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 18:45:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220807184548epoutp035eb2013d367aa7f15e20c0a7a5585b69~JJGO1CqYI2485424854epoutp03O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659897948;
        bh=lOaVuemJcvzVqvhmC9wH8jBWzJSDY06o4HSKqGiM8oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlTffWhms4f0hMSZu5S5Bfkd6r080Cm9EK5GrnYCNJR0xj+q7Y6123uoRSw0fCJ8z
         o4ACgrgS5Ar5+SQnIoPo61zNkmQz4Ny0/cc/gZd62vM4YW7T+zt1sO3jLq48b7IP/C
         TXCbSkyxHIhFiGL4r6L173sHr6cPGyJKlFw5bZfs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220807184547epcas5p48b2150fea628f5cbe39ab0f8af669c1c~JJGOLdDhN2500925009epcas5p4_;
        Sun,  7 Aug 2022 18:45:47 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4M17ZK1drvz4x9Pr; Sun,  7 Aug
        2022 18:45:45 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.E2.42669.95800F26; Mon,  8 Aug 2022 03:45:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220807184544epcas5p19f676581e0fdf555fa1d0a83906f2fc7~JJGLU98HN2851528515epcas5p1k;
        Sun,  7 Aug 2022 18:45:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220807184544epsmtrp1511305150dd7048a48ee916a1029a9da~JJGLTgwnS0046100461epsmtrp1D;
        Sun,  7 Aug 2022 18:45:44 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff7000001a6ad-85-62f00859fd47
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.35.08905.85800F26; Mon,  8 Aug 2022 03:45:44 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220807184543epsmtip26d826f46aa4317493d357010c81cda5d~JJGKIR7wE1262212622epsmtip2a;
        Sun,  7 Aug 2022 18:45:43 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v2 1/4] fs: add file_operations->uring_cmd_iopoll
Date:   Mon,  8 Aug 2022 00:06:04 +0530
Message-Id: <20220807183607.352351-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220807183607.352351-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTUzeS40OSwbJ3bBar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLvLW2L+cueslscmtzM5MDhcflsqcfmJfUeu282sHm833eVzaNv
        yypGj8+b5ALYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
        dN0yc4CuUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZY
        GRoYGJkCFSZkZ2w//Zi9YC9rxfVbJ9kaGI+xdDFyckgImEg0Nm9n7GLk4hAS2M0ocWz7GxYI
        5xOjxPuub+wQzjdGifkXTjDCtHT+nwvVspdRYuaHJjYI5zOQc+ElUIaDg01AU+LC5FKQBhEB
        eYkvt9eCjWUWWMsocXrvFyaQhLCAl0T3ie/MIDaLgKrE230TWUFsXgFLic+7+lghtslLzLz0
        nR1kJqeAlUTXFmWIEkGJkzOfgP3ADFTSvHU2M8h8CYGP7BIXbyyA6nWR2HzrIhuELSzx6vgW
        dghbSuJlfxuUnSxxaeY5Jgi7ROLxnoNQtr1E66l+ZpC9zEC/rN+lD7GLT6L39xMmkLCEAK9E
        R5sQRLWixL1JT6G2iks8nLEEyvaQOL5jJzR4ehklmmdMZJ/AKD8LyQuzkLwwC2HbAkbmVYyS
        qQXFuempxaYFRnmp5fCITc7P3cQITpRaXjsYHz74oHeIkYmD8RCjBAezkgjvkbXvk4R4UxIr
        q1KL8uOLSnNSiw8xmgKDeCKzlGhyPjBV55XEG5pYGpiYmZmZWBqbGSqJ83pd3ZQkJJCeWJKa
        nZpakFoE08fEwSnVwMTcJ7XC+3xM/snKvPbHV1NlU2S1pnE1HTJkml9S/JO/9bbp3NqKVYly
        /KoTWgT2MBlNTbA03Mm4Rvv9/ZazDEHP11yPDDNovp0vKfJ8507xV01snZbbPkdoaM5ZXZOv
        ldjvKuC+cvvW9B/Jj2Pui6iwXs3oq2JudPSPjfATXzV5MyfL3qT481Gx916c2W+5cPJrgcAo
        7Y1yZtcz+gvtrx+0LLPUKDk+h/twI5PcM96HbMwlZd9UOD0clHjFs3W/5x3ivvGfofekV5lI
        F+sjFeXN37hKw9N3K6resmk2KXsl/frViQ+Vz6UkvhdquN6xj46xdWy1+HSfY2q+861DqcU5
        a5+GJ07lXZSgyKHEUpyRaKjFXFScCACMslZzHQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSvG4Ex4ckg0VzZC1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8XeW9oW85c9Zbc4NLmZyYHD4/LZUo/NS+o9dt9sYPN4v+8qm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBlbD/9mL1gL2vF9Vsn2RoYj7F0MXJySAiYSHT+n8vY
        xcjFISSwm1Hi8vqVUAlxieZrP9ghbGGJlf+es0MUfWSUOL78BpDDwcEmoClxYXIpSI2IgKLE
        xo9NYIOYBTYzSnw6fYwZJCEs4CXRfeI7mM0ioCrxdt9EVhCbV8BS4vOuPlaIBfISMy99B5vJ
        KWAl0bVFGSQsBFRy9kILM0S5oMTJmU/AbmMGKm/eOpt5AqPALCSpWUhSCxiZVjFKphYU56bn
        FhsWGOallusVJ+YWl+al6yXn525iBIe4luYOxu2rPugdYmTiYDzEKMHBrCTCe2Tt+yQh3pTE
        yqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamLyKG8WX8uuGrA2p
        mBPybuPq81ecg+b/ym1euvXxEmsFX/8zhi6XHPTLXYN/nF7kvqzpzQlNznZf1Uk6t7OS52c1
        Pug8zCBfVnIyWe0BE/Py3+1fb/D6n85YePYk/0dNv6QfsuI/5XalqfXuD85J26xzKcwo0jFL
        bs3Tgg82zVvLl/8wrn91O+ni/k0BdzorDpTEcLCxKbOrFKZ2mcS2nZltHrTyfaXgLVVrl5Zf
        FT1ixf8+y3cfeDDzl9jGFfMEnD2T7y+f/5Ph5zSFJ5ov/kszzWNUi/gYP6EjdPJD+dD/LYU/
        C5M2rO1/MuF7XkroruVTUnI/bFBaGX5++6ZfMq9jd0msLhMP3p3XOD3QXImlOCPRUIu5qDgR
        AODKZNHgAgAA
X-CMS-MailID: 20220807184544epcas5p19f676581e0fdf555fa1d0a83906f2fc7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220807184544epcas5p19f676581e0fdf555fa1d0a83906f2fc7
References: <20220807183607.352351-1-joshi.k@samsung.com>
        <CGME20220807184544epcas5p19f676581e0fdf555fa1d0a83906f2fc7@epcas5p1.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring will trigger this to do completion polling on uring-cmd
operations.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9f131e559d05..449941f99f50 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2134,6 +2134,7 @@ struct file_operations {
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
+	int (*uring_cmd_iopoll)(struct io_uring_cmd *ioucmd);
 } __randomize_layout;
 
 struct inode_operations {
-- 
2.25.1

