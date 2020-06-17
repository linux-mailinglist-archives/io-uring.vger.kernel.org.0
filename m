Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDD91FD370
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 19:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgFQR1M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 13:27:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41043 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgFQR1K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 13:27:10 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200617172707epoutp021661bef4568cd3082887c0ad7723bfe1~ZZNlckdDE2436424364epoutp02I
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 17:27:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200617172707epoutp021661bef4568cd3082887c0ad7723bfe1~ZZNlckdDE2436424364epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592414828;
        bh=LBOG9REbmAYlHxyR7jvFKAsWiegyIQK04zGZkOS/AuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIVRo5P+85YJNvtuuFawNE3HwwsLkXdVdxOvwMCADalzbiDuM4IxSx+DDkZukEkoc
         AAt6jDlJL8y4vkF1yrCL1pIfvToZ1low1JB3j2MCnsGIcgIW/JGc1B4dHca7myxrYH
         5MCS7vNX88+qulds/3tvF/FpZzo/qmzm+YuBX300=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200617172707epcas5p22cf195448282ebdc2ef7834a5b393f9a~ZZNk6izzV1456214562epcas5p2u;
        Wed, 17 Jun 2020 17:27:07 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        67.B1.09703.B625AEE5; Thu, 18 Jun 2020 02:27:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200617172706epcas5p4dcbc164063f58bad95b211b9d6dfbfa9~ZZNkWh_sk1866218662epcas5p4h;
        Wed, 17 Jun 2020 17:27:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200617172706epsmtrp21060c8d107a2d39f9ec9248ee4cf3b76~ZZNkVqCpa0603706037epsmtrp2T;
        Wed, 17 Jun 2020 17:27:06 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-34-5eea526b99d7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.2C.08382.A625AEE5; Thu, 18 Jun 2020 02:27:06 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200617172704epsmtip1b3a347b0422349a9dbfab1eae38da006~ZZNiMuSIR0780107801epsmtip1G;
        Wed, 17 Jun 2020 17:27:04 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Arnav Dawn <a.dawn@samsung.com>
Subject: [PATCH 2/3] aio: add support for zone-append
Date:   Wed, 17 Jun 2020 22:53:38 +0530
Message-Id: <1592414619-5646-3-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsWy7bCmpm520Ks4g717hS1+b3vEYrH6bj+b
        Rde/LSwW71rPsVg8vvOZ3eLo/7dsFgs3LmOymDKtidFi7y1tiz17T7JYXN41h81i2+/5zBZX
        pixitnj94ySbxfm/x1kd+D0uny312PRpErtH35ZVjB6fN8l5bHrylimANYrLJiU1J7MstUjf
        LoErY9O+CywFK/kqNvxfz9rA+JO7i5GTQ0LAROLTyrVsXYxcHEICuxkl+vqbGEESQgKfGCWu
        TJWASHxjlFg8aSYjTMem2x+ZIYr2Mkrc3VUHUfSZUeLAhs1MXYwcHGwCmhIXJpeCmCICNhI7
        l6iAlDMLLGSS2PZMH8QWFjCV2LDsCthIFgFViYMvb4GN5BVwkvje+RZqlZzEzXOdYHFOAWeJ
        2ZsvsYKskhBo5ZBY8/cPM0SRi8Sfk2+YIGxhiVfHt7BD2FISn9/tZYOwiyV+3TnKDNHcwShx
        vWEmC0TCXuLinr9gNzMD3bx+lz7EoXwSvb+fgIUlBHglOtqEIKoVJe5NesoKYYtLPJyxBMr2
        kOi6M4UFEgzTGCXeLrrPPIFRdhbC1AWMjKsYJVMLinPTU4tNC4zyUsv1ihNzi0vz0vWS83M3
        MYITiJbXDsaHDz7oHWJk4mA8xCjBwawkwuv8+0WcEG9KYmVValF+fFFpTmrxIUZpDhYlcV6l
        H2fihATSE0tSs1NTC1KLYLJMHJxSDUyL5t/ns5j7MOZW2am3gireHe+CYlIzRM52xRmrt+o6
        LtQJXLo4O4lb0zFqxswN0y9bpGXYm56rfhd2riy9lpNT54vRxpUKhjXfdqakna5+03ugsrN/
        +fke50faHTO8lgR3Hgnb1Mn/W7L0gPHJmsWVusoPpMVtC5YtbF/LtCJprrty+uJF3YcaHptp
        2ipfk5lf21dW/jV9dtS/5X7yt7d6rEqqibrWtEXl/+ndn93fTAx4EB9aoOGh8TNs1m7Bq1d4
        Hmb+eqOswVBvPblGwYZpopHGu4nzVmiIHFzekxDNamUkWHr12zeLv1s5ft/9/+uHtRZz4vI9
        gid/vF+8nWNP5Os5NzxSKo4UvCtITFNiKc5INNRiLipOBACAoJPdjwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsWy7bCSnG5W0Ks4g9uTtC1+b3vEYrH6bj+b
        Rde/LSwW71rPsVg8vvOZ3eLo/7dsFgs3LmOymDKtidFi7y1tiz17T7JYXN41h81i2+/5zBZX
        pixitnj94ySbxfm/x1kd+D0uny312PRpErtH35ZVjB6fN8l5bHrylimANYrLJiU1J7MstUjf
        LoErY9O+CywFK/kqNvxfz9rA+JO7i5GTQ0LARGLT7Y/MXYxcHEICuxklLjSfZYVIiEs0X/vB
        DmELS6z895wdougjo0TvrMdADgcHm4CmxIXJpSA1IgIOEl3HHzOB1DALrGWSeDdlIyNIQljA
        VGLDsitgNouAqsTBl7eYQWxeASeJ751vGSEWyEncPNcJFucUcJaYvfkS2BFCQDV/Fs1incDI
        t4CRYRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnAIa2nuYNy+6oPeIUYmDsZDjBIc
        zEoivM6/X8QJ8aYkVlalFuXHF5XmpBYfYpTmYFES571RuDBOSCA9sSQ1OzW1ILUIJsvEwSnV
        wLT3uIqg5B7H8B97Jlpun8m15+epddz3M7qTnyr67dpV5Bp+5/7aL9ffaay4/p3j5n47nbgb
        OfNu7mX/vW3S0t5CNZmnNpPvpjfvrOJfffLoFO9c20cClxe8OvSwTnLyw8IWD3X1tD1mJUrz
        xFvmZx0OZ3ZwF5zZs2t10Pbttr3hWQXrbk7aFlLubLGwNH7hmrbKOb8tevZOyWjyrUo+KbR7
        jffVHuNTM+41lvxNEY84aP4ySyLr2rqlXDesZPuFT978xn9ULq5n+uOne0LSYpa++yj5jbuJ
        /blFR/f1fb41nAsabnlE9a2RX3G2uEgu5amPd3LPpgOHTpfP8mU6NXe9y6JDqeUR82/ZZW98
        bc6nxFKckWioxVxUnAgAqm13RdACAAA=
X-CMS-MailID: 20200617172706epcas5p4dcbc164063f58bad95b211b9d6dfbfa9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200617172706epcas5p4dcbc164063f58bad95b211b9d6dfbfa9
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
        <CGME20200617172706epcas5p4dcbc164063f58bad95b211b9d6dfbfa9@epcas5p4.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce IOCB_CMD_ZONE_APPEND opcode for zone-append. On append
completion zone-relative offset is returned using io_event->res2.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Arnav Dawn <a.dawn@samsung.com>
Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 fs/aio.c                     | 8 ++++++++
 include/uapi/linux/aio_abi.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 7ecddc2..8b10a55d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1579,6 +1579,10 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 			__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);
 			__sb_writers_release(file_inode(file)->i_sb, SB_FREEZE_WRITE);
 		}
+#ifdef CONFIG_BLK_DEV_ZONED
+		if (iocb->aio_lio_opcode == IOCB_CMD_ZONE_APPEND)
+			req->ki_flags |= IOCB_ZONE_APPEND;
+#endif
 		req->ki_flags |= IOCB_WRITE;
 		aio_rw_done(req, call_write_iter(file, req, &iter));
 	}
@@ -1846,6 +1850,10 @@ static int __io_submit_one(struct kioctx *ctx, const struct iocb *iocb,
 		return aio_fsync(&req->fsync, iocb, true);
 	case IOCB_CMD_POLL:
 		return aio_poll(req, iocb);
+#ifdef CONFIG_BLK_DEV_ZONED
+	case IOCB_CMD_ZONE_APPEND:
+		return aio_write(&req->rw, iocb, false, compat);
+#endif
 	default:
 		pr_debug("invalid aio operation %d\n", iocb->aio_lio_opcode);
 		return -EINVAL;
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index 8387e0a..541d96a 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -43,6 +43,7 @@ enum {
 	IOCB_CMD_NOOP = 6,
 	IOCB_CMD_PREADV = 7,
 	IOCB_CMD_PWRITEV = 8,
+	IOCB_CMD_ZONE_APPEND = 9,
 };
 
 /*
-- 
2.7.4

